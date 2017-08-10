require 'rails_helper'

RSpec.describe "Types::PostType", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let!(:viewer) { build(:viewer) }
  let(:user) { viewer.user }
  let!(:user_posts) { create_list(:post, 3, creatorId: user.id) }
  let!(:other_posts) { create_list(:post, 5) }
  let(:user_post) { user_posts.last }

  describe "PostType" do

    describe "All the posts" do
      let(:query) {
        <<-GRAPHQL
          {
            viewer {
              posts {
                edges {
                  node {
                    id, creator { firstName }, title, image, description
                  }
                }
              }
            }
          }
        GRAPHQL
      }
      
      it "returns all the posts" do
        post(endpoint, params: { query: query })
        expect(json['viewer']['posts']['edges'].count).to eq(Datastore.posts.count)
      end

      it "supports pagination for posts" do
        first_query = <<-GRAPHQL
          {
            viewer {
              posts(first: 1) {
                edges {
                  cursor,
                  node {
                    id, creator { firstName }, title, image, description
                  }
                }
              }
            }
          }
        GRAPHQL
        
        post(endpoint, params: { query: first_query })
        
        cursor = json['viewer']['posts']['edges'][0]['cursor']
        expect(cursor).not_to be_blank

        first_post_json = json['viewer']['posts']['edges'][0]['node']
        first_post = Datastore.posts.first
        expect(first_post_json['id']).to eq(first_post[:id].to_s)
        expect(first_post_json['title']).to eq(first_post[:title])
        expect(first_post_json['image']).to eq(first_post[:image])

        second_query = <<-GRAPHQL
          {
            viewer {
              posts(first: 1 after: "#{cursor}") {
                edges {
                  node {
                    id, creator { firstName }, title, image, description
                  }
                }
              }
            }
          }
        GRAPHQL

        post(endpoint, params: { query: second_query })

        second_post_json = JSON.parse(response.body)["data"]['viewer']['posts']['edges'][0]['node']
        second_post = Datastore.posts.all[1]
        expect(second_post_json['id']).to eq(second_post[:id].to_s)
        expect(second_post_json['title']).to eq(second_post[:title])
        expect(second_post_json['image']).to eq(second_post[:image])
      end
    end

    describe "a post requested by id" do
      let(:query) {
        <<-GRAPHQL
          query ViewerQuery($postId: String){
            viewer {
              post(postId: $postId) {
                id
                title    
                description
                image                                                    
              }
            }
          }
        GRAPHQL
      }

      let(:variables) {{
        "postId" => user_post.id      
      }}

      shared_examples "returning a post" do
        it "returns a user" do
          post(endpoint, params: { query: query, variables: variables })

          post_json = json["viewer"]["post"]
          expect(post_json["id"]).to eq(user_post.id.to_s)
          expect(post_json["title"]).to eq(user_post.title)
          expect(post_json["description"]).to eq(user_post.description)
          expect(post_json["image"]).to eq(user_post.image)
        end
      end

      context "Logged in" do
        before(:each) {
          allow_any_instance_of(Warden::Proxy).to receive(:user).and_return(viewer)
        }

        it_behaves_like "returning a post"
      end

      context "Not logged in" do
        it_behaves_like "returning a post"
      end
    end
  end
end
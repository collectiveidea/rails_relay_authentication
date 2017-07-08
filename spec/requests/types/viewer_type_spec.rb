require 'rails_helper'

RSpec.describe "Types::ViewerType", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let(:viewer) { build(:viewer) }
  let(:user) { viewer.user }
  let!(:user_posts) { create_list(:post, 3, user: user) }
  let!(:other_posts) { create_list(:post, 5) }
  let(:post_count) { user_posts.count + other_posts.count }
  let(:single_post) { other_posts.last }

  describe "ViewerType" do
    let(:query) {
      <<-GRAPHQL
        query ViewerQuery($postId: String){
          viewer {
            user {
              id
              firstName
              lastName
              email                                          
            }
            posts {
              edges {
                node {
                  id
                  title
                  description
                }
              }
            }
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
      "postId" => single_post.uuid      
    }}

    shared_examples "returning a viewer with all the posts" do
      it "returns a viewer with posts" do
        post(endpoint, params: { query: query, variables: variables }  )

        expect(json["viewer"].keys).to eq(%w(user posts post))
        expect(json["viewer"]["user"]["id"]).to eq(user.uuid)
        expect(json["viewer"]["posts"]["edges"].count).to eq(post_count)

        posts_json = json["viewer"]["posts"]["edges"].map { |edge| edge["node"] }
        expect(posts_json.map { |item| item["id"] }.compact.length).to eq(post_count)
        expect(posts_json.map { |item| item["title"] }.compact.length).to eq(post_count)
        expect(posts_json.map { |item| item["description"] }.compact.length).to eq(post_count)

        post_json = json["viewer"]["post"]
        expect(post_json["id"]).to eq(single_post.uuid)
        expect(post_json["title"]).to eq(single_post.title)
        expect(post_json["description"]).to eq(single_post.description)
        expect(post_json["image"]).to eq(single_post.image)
      end
    end

    describe "Logged in" do
      before(:each) {
        allow_any_instance_of(Warden::Proxy).to receive(:user).and_return(viewer)
      }

      context "publisher" do
        it_behaves_like "returning a viewer with all the posts"
      end

      context "admin" do
        let(:viewer) { build(:viewer, :admin) }

        it_behaves_like "returning a viewer with all the posts"
      end
    end
  end
end
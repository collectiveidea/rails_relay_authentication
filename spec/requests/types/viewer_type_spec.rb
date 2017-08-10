require 'rails_helper'

RSpec.describe "Types::ViewerType", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let(:viewer) { build(:viewer) }
  let(:user) { viewer.user }
  let!(:user_posts) { create_list(:post, 3, creatorId: user.id) }
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
            }
            posts {
              edges {
                node {
                  id
                }
              }
            }
            post(postId: $postId) {
              id
            }
          }
        }
      GRAPHQL
    }

    let(:variables) {{
      "postId" => single_post.id      
    }}

    shared_examples "returning a viewer with all the posts" do
      it "returns a viewer with posts" do
        post(endpoint, params: { query: query, variables: variables })

        post_ids = json["viewer"]["posts"]["edges"].map { |edge| edge["node"]["id"] }

        expect(json["viewer"].keys).to eq(%w(user posts post))
        expect(json["viewer"]["user"]["id"]).to eq(user.id.to_s)
        expect(post_ids).to eq(API::Post.all.map(&:id).map(&:to_s))
        expect(json["viewer"]["post"]["id"]).to eq(single_post.id.to_s)
      end
    end

    context "Logged in" do
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

    context "Not logged in" do
      it "shows post data but does not show any user data" do
        post(endpoint, params: { query: query, variables: variables })

        post_ids = json["viewer"]["posts"]["edges"].map { |edge| edge["node"]["id"] }

        expect(json["viewer"].keys).to eq(%w(user posts post))
        expect(json["viewer"]["user"]).to be_nil
        expect(post_ids).to eq(API::Post.all.map(&:id).map(&:to_s))
        expect(json["viewer"]["post"]["id"]).to eq(single_post.id.to_s)
      end
    end
  end
end
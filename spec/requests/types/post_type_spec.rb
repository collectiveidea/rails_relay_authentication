require 'rails_helper'

RSpec.describe "Types::PostType", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let!(:viewer) { build(:viewer) }
  let(:user) { viewer.user }
  let!(:user_posts) { create_list(:post, 3, user_id: user.id) }
  let!(:other_posts) { create_list(:post, 5) }
  let(:user_post) { user_posts.last }

  describe "PostType" do
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
        expect(post_json["id"]).to eq(user_post.id)
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
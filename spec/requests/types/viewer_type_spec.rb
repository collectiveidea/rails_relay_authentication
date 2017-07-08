require 'rails_helper'

RSpec.describe "Types::ViewerType", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let(:viewer) { build(:viewer) }
  let(:user) { viewer.user }
  let!(:user_posts) { create_list(:post, 3, user: user) }
  let!(:other_posts) { create_list(:post, 5) }
  let(:post_count) { user_posts.count + other_posts.count }
  
  describe "ViewerType" do
    let(:query) {
      <<-GRAPHQL
        {
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
          }
        }
      GRAPHQL
    }

    shared_examples "returning a viewer with all the posts" do
      it "returns a viewer with posts" do
        post(endpoint, params: { query: query }  )

        expect(json["viewer"].keys).to eq(%w(user posts))
        expect(json["viewer"]["user"]["id"]).to eq(user.uuid)
        expect(json["viewer"]["posts"]["edges"].count).to eq(post_count)

        posts_json = json["viewer"]["posts"]["edges"].map { |edge| edge["node"] }
        expect(posts_json.map { |item| item["id"] }.compact.length).to eq(post_count)
        expect(posts_json.map { |item| item["title"] }.compact.length).to eq(post_count)
        expect(posts_json.map { |item| item["description"] }.compact.length).to eq(post_count)
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
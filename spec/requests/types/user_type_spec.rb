require 'rails_helper'

RSpec.describe "Types::UserType", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let!(:user) { create(:user) }
  let(:viewer) { build(:viewer, id: user.id, role: user.role) }
  let!(:user_posts) { create_list(:post, 3, creatorId: user.id) }
  let!(:other_posts) { create_list(:post, 5) }

  let(:user_json) { json["viewer"]["user"] }

  describe "UserType" do
    let(:query) {
      <<-GRAPHQL
        {
          viewer {
            user {
              id
              email
              firstName
              lastName
              role    
              posts {
                edges {
                  node {
                    id
                  }
                }
              }                                       
            }
          }
        }
      GRAPHQL
    }

    context "Logged in" do
      before(:each) {
        allow_any_instance_of(Warden::Proxy).to receive(:user).and_return(viewer)
      }

      it "returns a user" do
        post(endpoint, params: { query: query }  )
        
        expect(user_json["id"]).to eq(user.id.to_s)
        expect(user_json["email"]).to eq(user.email)
        expect(user_json["firstName"]).to eq(user.firstName)
        expect(user_json["lastName"]).to eq(user.lastName)
        expect(user_json["role"]).to eq(user.role)
        expect(user_json["posts"]["edges"].count).to eq(user_posts.count)
        expect(user_json["posts"]["edges"].map { |edge| edge["node"]["id"] }).to match_array(user_posts.map(&:id).map(&:to_s))
      end
    end

    context "Not logged in" do
      it "does not return a user" do
        post(endpoint, params: { query: query }  )

        expect(user_json).to be_nil
      end
    end
  end
end
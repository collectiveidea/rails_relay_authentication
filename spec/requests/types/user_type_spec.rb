require 'rails_helper'

RSpec.describe "Types::UserType", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let!(:viewer) { build(:viewer) }
  let(:user) { viewer.user }
  let!(:user_posts) { create_list(:post, 3, user: user) }
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

    describe "Logged in" do
      before(:each) {
        allow_any_instance_of(Warden::Proxy).to receive(:user).and_return(viewer)
      }

      it "returns a user" do
        post(endpoint, params: { query: query }  )

        expect(user_json["id"]).to eq(user.uuid)
        expect(user_json["email"]).to eq(user.email)
        expect(user_json["firstName"]).to eq(user.first_name)
        expect(user_json["lastName"]).to eq(user.last_name)
        expect(user_json["role"]).to eq(user.role)
        expect(user_json["posts"]["edges"].count).to eq(user_posts.count)
        expect(user_json["posts"]["edges"].map { |edge| edge["node"]["id"] }).to eq(user_posts.map(&:uuid))
      end
    end
  end
end
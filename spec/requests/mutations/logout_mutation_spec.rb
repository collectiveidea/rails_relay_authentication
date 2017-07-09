require 'rails_helper'

RSpec.describe "Mutations::LogoutMutation", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let!(:viewer) { build(:viewer, :admin) }
  let(:user) { viewer.user }

  describe "LogoutMutation" do
    let(:query) {
      <<-GRAPHQL
        mutation Logout($input: LogoutInput!){
          logout(input: $input) {
            user {
              id
              email    
              firstName
              lastName
              role                                                                  
            }
          }
        }
      GRAPHQL
    }

    let(:variables) {{
      "input" => {
        "clientMutationId" => "1"        
      }      
    }}

    context "Logged in" do
      before(:each) {
        allow_any_instance_of(Warden::Proxy).to receive(:user).and_return(viewer)
      }

      it "returns a user" do
        post(endpoint, params: { query: query, variables: variables })

        user_json = json["logout"]["user"]
        expect(user_json["email"]).to eq(user.email)
        expect(user_json["firstName"]).to eq(user.firstName)
        expect(user_json["lastName"]).to eq(user.lastName)
        expect(user_json["role"]).to eq(user.role)
      end
    end

    context "Not logged in" do
      it "returns a nil value for user" do
        post(endpoint, params: { query: query, variables: variables })

        expect(json["logout"]["user"]).to be_nil
      end
    end
  end
end
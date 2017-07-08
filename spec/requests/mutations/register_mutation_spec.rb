require 'rails_helper'

RSpec.describe "Mutations::RegisterMutation", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let(:new_user) { build(:user, :reader) }

  describe "RegisterMutation" do
    let(:query) {
      <<-GRAPHQL
        mutation RegisterMutation($input: RegisterInput!){
          register(input: $input) {
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
        "email" => new_user.email,
        "firstName" => new_user.first_name,
        "lastName" => new_user.last_name,
        "password" => "foobarbaz"                                
      }      
    }}

    context "Not logged in" do
      it "returns a user" do
        post(endpoint, params: { query: query, variables: variables })

        user_json = json["register"]["user"]
        expect(user_json["email"]).to eq(new_user.email)
        expect(user_json["firstName"]).to eq(new_user.firstName)
        expect(user_json["lastName"]).to eq(new_user.lastName)
        expect(user_json["role"]).to eq(new_user.role)

        user = User.all.last
        expect(user.email).to eq(new_user.email)
        expect(user.firstName).to eq(new_user.firstName)
        expect(user.lastName).to eq(new_user.lastName)
        expect(user.role).to eq(new_user.role)
      end
    end
  end
end
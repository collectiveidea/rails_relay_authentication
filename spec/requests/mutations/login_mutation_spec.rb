require 'rails_helper'

RSpec.describe "Mutations::LoginMutation", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let(:password) { "foobarbaz" }
  let!(:user) { create(:user, password: password) }

  describe "LoginMutation" do
    let(:query) {
      <<-GRAPHQL
        mutation LoginMutation($input: LoginInput!){
          login(input: $input) {
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
        "email" => user.email,
        "password" => password                                
      }      
    }}

    context "Not logged in" do
      it "returns a user" do
        post(endpoint, params: { query: query, variables: variables })

        user_json = json["login"]["user"]
        expect(user_json["email"]).to eq(user.email)
        expect(user_json["firstName"]).to eq(user.firstName)
        expect(user_json["lastName"]).to eq(user.lastName)
        expect(user_json["role"]).to eq(user.role)
      end

      describe "errors" do
        let(:errors) { JSON.parse(response.body)["errors"] }

        let(:register_user) {
          post(endpoint, params: { query: query, variables: variables })          
        }

        it "requires an email address" do
          variables["input"].merge!("email" => nil)

          expect {
            register_user
          }.not_to change(User.all, :count)

          expect(errors.first["message"]).to eq("Variable input of type LoginInput! was provided invalid value")
        end

        it "requires a valid email address" do
          variables["input"].merge!("email" => "foo")

          expect {
            register_user
          }.not_to change(User.all, :count)
          expect(errors.first["message"]).to eq("Wrong email or password")
        end

        it "requires a password" do
          variables["input"].merge!("password" => nil)

          expect {
            register_user
          }.not_to change(User.all, :count)
          
          expect(errors.first["message"]).to eq("Variable input of type LoginInput! was provided invalid value")
        end
      end
    end
  end
end
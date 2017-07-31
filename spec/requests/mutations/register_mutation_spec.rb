require 'rails_helper'

RSpec.describe "Mutations::RegisterMutation", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let(:viewer) { build(:viewer) }
  let(:new_user) { attributes_for(:user) }

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
        "email" => new_user[:email],
        "firstName" => new_user[:firstName],
        "lastName" => new_user[:lastName],
        "password" => "foobarbaz"                                
      }      
    }}

    let(:register_user) {
      post(endpoint, params: { query: query, variables: variables })          
    }

    let(:errors) { JSON.parse(response.body)["errors"] }

    context "Logged in" do
      before(:each) {
        allow_any_instance_of(Warden::Proxy).to receive(:user).and_return(viewer)
      }

      it "does not let a logged in user register" do
        expect {
          register_user
        }.not_to change { API::User.all.count }

        expect(errors.first["message"]).to eq("Forbidden")
      end
    end

    context "Not logged in" do
      it "returns a user" do
        expect {
          register_user
        }.to change { API::User.all.count }.by(1)

        user_json = json["register"]["user"]
        expect(user_json["email"]).to eq(new_user[:email])
        expect(user_json["firstName"]).to eq(new_user[:firstName])
        expect(user_json["lastName"]).to eq(new_user[:lastName])
        #expect(user_json["role"]).to eq(new_user[:role]) # Fix the role thing in mutations

        user = API::User.all.last
        expect(user.email).to eq(new_user[:email])
        expect(user.firstName).to eq(new_user[:firstName])
        expect(user.lastName).to eq(new_user[:lastName])
        #expect(user.role).to eq(new_user[:role])
      end

      describe "errors" do
        it "requires an email address" do
          variables["input"].merge!("email" => nil)

          expect {
            register_user
          }.not_to change(API::User.all, :count)

          expect(errors).not_to be_nil
        end

        it "requires a valid email address" do
          variables["input"].merge!("email" => "foo")

          expect {
            register_user
          }.not_to change(API::User.all, :count)
          expect(errors).not_to be_nil
        end

        it "requires a password" do
          variables["input"].merge!("password" => nil)

          expect {
            register_user
          }.not_to change(API::User.all, :count)
          
          expect(errors).not_to be_nil
        end
      end
    end
  end
end
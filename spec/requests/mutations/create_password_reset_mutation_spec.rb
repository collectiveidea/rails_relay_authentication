require 'rails_helper'

RSpec.describe "Mutations::CreatePasswordResetMutation", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let(:password) { "foobarbaz" }
  let!(:user) { create(:user, password: password) }

  describe "CreatePasswordResetMutation" do
    let(:query) {
      <<-GRAPHQL
        mutation CreatePasswordResetMutation($input: CreatePasswordResetInput!){
          createPasswordReset(input: $input) {
            user {
              id
            }
          }
        }
      GRAPHQL
    }

    let(:variables) {{
      "input" => {
        "email" => user.email
      }      
    }}

    let(:errors) { JSON.parse(response.body)["errors"] }

    let(:viewer) { create(:viewer, user: user) }

    context "Logged in" do
      before(:each) {
        allow_any_instance_of(Warden::Proxy).to receive(:user).and_return(viewer)
      }

      it "does not let a logged in user reset a password" do
        expect {
          post(endpoint, params: { query: query, variables: variables })
        }.not_to change { API::PasswordReset.all.count }

        expect(errors.first["message"]).to eq("Forbidden")
      end
    end
  
    context "Not logged in" do
      it "creates a password reset record in the database" do
        post(endpoint, params: { query: query, variables: variables })

        expect(json["createPasswordReset"]["user"]).to be_nil

        password_reset = Datastore.password_resets.first
        expect(password_reset[:user_id]).to eq(user.id)
        expect(password_reset[:token]).to be_a(String)
        expect(password_reset[:token].length).to eq(32)
        expect(password_reset[:created_at]).to be_within(1.minute).of Time.now
        expect(password_reset[:expires_at]).to be_within(1.minute).of 1.week.from_now
      end

      it "deletes any existing password_resets for this user" do
        existing_token = API::CreatePasswordReset.call(email: user.email).token

        expect {
          post(endpoint, params: { query: query, variables: variables })
        }.not_to change { Datastore.password_resets.count }

        expect(json["createPasswordReset"]["user"]).to be_nil

        password_reset = Datastore.password_resets.first
        expect(password_reset[:user_id]).to eq(user.id)
        expect(password_reset[:token]).to be_a(String)
        expect(password_reset[:token].length).to eq(32)
        expect(password_reset[:token]).not_to eq(existing_token)
        expect(password_reset[:created_at]).to be_within(1.minute).of Time.now
        expect(password_reset[:expires_at]).to be_within(1.minute).of 1.week.from_now
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
          }.not_to change(API::User, :count)

          expect(errors.first["message"]).to eq("Variable input of type CreatePasswordResetInput! was provided invalid value")
        end

        it "requires a valid email address" do
          variables["input"].merge!("email" => "foo")

          expect {
            register_user
          }.not_to change(API::User, :count)
          expect(errors.first["message"]).to eq("User not found")
        end
      end
    end
  end
end
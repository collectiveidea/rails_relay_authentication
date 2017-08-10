require 'rails_helper'

RSpec.describe "Mutations::ResetPasswordMutation", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let(:password) { "foobarbaz" }
  let(:new_password) { "bazbarfoo" }
  let!(:user) { create(:user, password: password) }
  let(:viewer) { create(:viewer, user: user) }
  let!(:password_reset_token) { API::CreatePasswordReset.call(email: user.email).token }

  describe "ResetPasswordMutation" do
    let(:query) {
      <<-GRAPHQL
        mutation ResetPasswordMutation($input: ResetPasswordInput!){
          resetPassword(input: $input) {
            user {
              id
              email
            }
          }
        }
      GRAPHQL
    }

    let(:variables) {{
      "input" => {
        "newPassword" => new_password,
        "token" => password_reset_token
      }
    }}

    let(:errors) { JSON.parse(response.body)["errors"] }

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
      it "updates the user's password in the database" do
        expect {
          post(endpoint, params: { query: query, variables: variables })
        }.to change {
          API::User.find(user.id).password_digest          
        }

        user_json = json["resetPassword"]["user"]

        expect(user_json['id']).to eq(user.id.to_s)

        expect(Datastore.password_resets.where(user_id: user.id)).to be_empty
      end

      describe "errors" do
        # TODO: password length and format sad path specs

        let(:errors) { JSON.parse(response.body)["errors"] }

        let(:reset_password) {
          post(endpoint, params: { query: query, variables: variables })          
        }

        it "requires a new password" do
          variables["input"].merge!("newPassword" => "")

          expect {
            reset_password
          }.not_to change(API::User, :count)

          expect(errors.first["message"]).to eq("New password required")
        end

        it "requires a valid reset token" do
          variables["input"].merge!("token" => "foo")

          expect {
            reset_password
          }.not_to change(API::User, :count)
          expect(errors.first["message"]).to eq("Token not found")
        end
      end
    end
  end
end
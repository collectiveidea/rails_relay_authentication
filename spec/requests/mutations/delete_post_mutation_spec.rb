require 'rails_helper'

RSpec.describe "Mutations::DeletePostMutation", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let(:image_path) { Rails.root.join("spec", "fixtures", "image1.jpg") }

  let(:viewer) { build(:viewer) }
  let(:user) { viewer.user }
  let!(:existing_post) { create(:post, creatorId: user.id) }

  describe "DeletePostMutation" do
    let(:query) {
      <<-GRAPHQL
        mutation DeletePostMutation(
          $input: DeletePostInput!
        ) {
          deletePost(input: $input) {
            user {
              id
            }
          }
        }
      GRAPHQL
    }

    let(:variables) {{
      "input" => { "id" => existing_post.id }      
    }}

    let(:delete_post) {
      post(endpoint, params: { query: query, variables: variables })          
    }

    context "Logged in" do
      before(:each) {
        allow_any_instance_of(Warden::Proxy).to receive(:user).and_return(viewer)
        allow(FileUtils).to receive(:mv)
      }

      it "deletes a post" do
        expect {
          delete_post                    
        }.to change { Datastore.posts.count }.by(-1)

        expect(Datastore.posts.where(id: existing_post.id).any?).to eq(false)

        user_json = json["deletePost"]["user"]
        expect(user_json["id"]).to eq(existing_post.creatorId)
      end

      describe "errors" do
        let(:errors) { JSON.parse(response.body)["errors"] }

        it "requires an id" do
          variables["input"].merge!("id" => nil)

          expect {
            delete_post
          }.not_to change { Datastore.posts.count }

          expect(errors.first["message"]).to include("Variable input of type DeletePostInput! was provided invalid value")                 
        end

        context "not an viewer is a reader" do
          let(:viewer) { build(:viewer, :reader)}
          let(:user) { build(:user) }

          it "does not let a reader delete a post" do
            expect {
              delete_post
            }.not_to change { Datastore.posts.count }
            expect(errors.first["message"]).to include("Forbidden")
          end
        end
      end
    end
  end
end
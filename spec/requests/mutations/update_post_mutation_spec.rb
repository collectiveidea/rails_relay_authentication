require 'rails_helper'

RSpec.describe "Mutations::UpdatePostMutation", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let!(:user) { create(:user) }
  let!(:viewer) { create(:viewer, user: user) }
  let(:image_path) { Rails.root.join("spec", "fixtures", "image1.jpg") }
  let(:existing_post) { create(:post, creatorId: user.id) }
  let(:new_title) { "New title" }
  let(:new_description) { "New description" }

  describe "UpdatePostMutation" do
    let(:query) {
      <<-GRAPHQL
        mutation UpdatePostMutation(
          $input: UpdatePostInput!
        ) {
          updatePost(input: $input) {
            post {
              id
              title
              description
              image
            }
          }
        }
      GRAPHQL
    }

    let(:variables) {{
      "input" => {
        "id" => existing_post.id,
        "title" => new_title
      }      
    }}

    let(:update_post) {
      post(endpoint, params: { query: query, variables: variables })          
    }

    let(:errors) { JSON.parse(response.body)["errors"] }

    context "Logged in" do
      before(:each) {
        allow_any_instance_of(Warden::Proxy).to receive(:user).and_return(viewer)
        allow(FileUtils).to receive(:mv)
      }

      it "updates a post" do
        expect {
          update_post
        }.to change { Datastore.posts.where(uuid: existing_post.id).first }
        
        post_json = json["updatePost"]["post"]
        expect(post_json["title"]).to eq(new_title)
        expect(post_json["description"]).to eq(existing_post.description)
        expect(post_json["image"]).to eq(existing_post.image)

        db_post = API::Post.all.last
        expect(db_post.title).to eq(new_title)
        expect(db_post.description).to eq(existing_post.description)
        expect(db_post.image).to eq(existing_post.image)
      end

      describe "errors" do
        it "requires at least one field" do
          variables["input"] = { "id" => existing_post.id }

          expect {
            update_post
          }.not_to change { Datastore.posts.where(uuid: existing_post.id).first }
          expect(errors.first["message"]).to include("Nothing to do")
        end

        context "not the post's author" do
          let(:viewer) { build(:viewer)}

          it "does not let someone other than the post's author update the post" do
            expect {
              update_post
            }.not_to change { Datastore.posts.where(uuid: existing_post.id).first }
            expect(errors.first["message"]).to include("Forbidden")
          end
        end

        context "is an admin" do
          let(:viewer) { build(:viewer, :admin)}

          it "let's an admin other than the post's author update the post" do
            expect {
              update_post
            }.to change { Datastore.posts.where(uuid: existing_post.id).first }
          end
        end

      end
    end

    context "Not logged in" do
      it "does not update a post" do
        expect {
          update_post
        }.not_to change { Datastore.posts.where(uuid: existing_post.id).first }
      end
    end
  end
end
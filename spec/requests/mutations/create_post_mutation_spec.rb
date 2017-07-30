require 'rails_helper'

RSpec.describe "Mutations::CreatePostMutation", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let!(:viewer) { build(:viewer, :admin) }
  let(:image_path) { Rails.root.join("spec", "fixtures", "image1.jpg") }
  let(:new_post) { attributes_for(:post, creatorId: viewer.user.id) }

  describe "CreatePostMutation" do
    let(:query) {
      <<-GRAPHQL
        mutation CreatePostMutation(
          $input: CreatePostInput!
        ) {
          createPost(input: $input) {
            postEdge {
              node {
                id
                title
                description
                image
              }
            }
          }
        }
      GRAPHQL
    }

    let(:variables) {{
      "input" => {
        "title" => new_post[:title],
        "description" => new_post[:description],
        "image" => fixture_file_upload(Rails.root.join('spec', 'fixtures', 'image1.jpg'), 'image/jpg')
      }      
    }}

    let(:create_post) {
      post(endpoint, params: { query: query, variables: variables })          
    }

    context "Logged in" do
      before(:each) {
        allow_any_instance_of(Warden::Proxy).to receive(:user).and_return(viewer)
        allow(FileUtils).to receive(:mv)
      }

      it "returns a post" do
        expect {
          create_post                    
        }.to change { Datastore.posts.count }.by(1)
        
        post_json = json["createPost"]["postEdge"]["node"]
        expect(post_json["title"]).to eq(new_post[:title])
        expect(post_json["description"]).to eq(new_post[:description])
        expect(post_json["image"]).to eq("/images/upload/image1.jpg")

        post = API::Post.all.last
        expect(post.title).to eq(new_post[:title])
        expect(post.description).to eq(new_post[:description])
        expect(post.image).to eq("/images/upload/image1.jpg")
      end

      describe "errors" do
        let(:errors) { JSON.parse(response.body)["errors"] }

        it "requires a title" do
          variables["input"].merge!("title" => nil)

          expect {
            create_post
          }.not_to change(API::Post.all, :count)

          expect(errors.first["message"]).to include("title")
          expect(errors.first["message"]).to include("must be filled")           
        end

        it "requires a valid description" do
          variables["input"].merge!("description" => nil)

          expect {
            create_post
          }.not_to change(API::Post.all, :count)

          expect(errors.first["message"]).to include("description")
          expect(errors.first["message"]).to include("must be filled")           
        end

        it "requires an image" do
          variables["input"].merge!("image" => nil)

          expect {
            create_post
          }.not_to change(API::Post.all, :count)
          
          expect(errors.first["message"]).to include("image")
          expect(errors.first["message"]).to include("must be filled")           
        end

        context "not an admin" do
          let(:viewer) { build(:viewer, :reader)}

          it "does not let a reader create a post" do
            expect {
              create_post
            }.not_to change { Datastore.posts.count }
            expect(errors.first["message"]).to include("Forbidden")
          end
        end
      end
    end
  end
end
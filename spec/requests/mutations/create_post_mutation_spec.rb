require 'rails_helper'

RSpec.describe "Mutations::CreatPostMutation", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let!(:viewer) { build(:viewer, :admin) }
  let(:image_path) { Rails.root.join("spec", "fixtures", "image1.jpg") }
  let(:new_post) { build(:post, image: "/images/upload/image1.jpg", user_id: viewer.user.id) }
  let(:new_post_image) {
    fixture_file_upload(image_path)    
  }

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
        "title" => new_post.title,
        "description" => new_post.description,
        "image" => new_post_image,
      }      
    }}

    context "Logged in" do
      before(:each) {
        allow_any_instance_of(Warden::Proxy).to receive(:user).and_return(viewer)
        allow(FileUtils).to receive(:mv)
      }

      it "returns a user" do
        post(endpoint, params: { query: query, variables: variables })

        post_json = json["createPost"]["postEdge"]["node"]
        expect(post_json["title"]).to eq(new_post.title)
        expect(post_json["description"]).to eq(new_post.description)
        expect(post_json["image"]).to eq(new_post.image)

        post = Post.all.last
        expect(post.title).to eq(new_post.title)
        expect(post.description).to eq(new_post.description)
        expect(post.image).to eq(new_post.image)
      end

      describe "errors" do
        let(:errors) { JSON.parse(response.body)["errors"] }

        let(:create_post) {
          post(endpoint, params: { query: query, variables: variables })          
        }

        it "requires a title" do
          variables["input"].merge!("title" => nil)

          expect {
            create_post
          }.not_to change(Post.all, :count)

          expect(errors).not_to be_nil
        end

        it "requires a valid description" do
          variables["input"].merge!("description" => "foo")

          expect {
            create_post
          }.not_to change(Post.all, :count)
          binding.pry
          expect(errors).not_to be_nil
        end

        it "requires an image" do
          variables["input"].merge!("image" => nil)

          expect {
            create_post
          }.not_to change(Post.all, :count)
          
          expect(errors).not_to be_nil
        end
      end
    end
  end
end
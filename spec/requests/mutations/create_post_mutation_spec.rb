require 'rails_helper'

RSpec.describe "Mutations::CreatPostMutation", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let!(:viewer) { build(:viewer, :admin) }
  let(:new_post) { build(:post, user: viewer.user) }

  let(:new_post_image) {
    instance_double(
      "ActionDispatch::Http::UploadedFile", 
      original_filename: new_post.image,
      tempfile: :tempfile
    )    
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

        allow(FileUtils).to receive(:mv) do |source, dest|
          expect(source).to eq(new_image.tempfile)
          expect(dest).to eq(Rails.root.join("static", "images", "upload", new_image.original_filename))
        end
      }

      it "returns a user" do
        post(endpoint, params: { query: query, variables: variables })

        user_json = json["createPost"]["user"]
        expect(user_json["email"]).to eq(user.email)
        expect(user_json["firstName"]).to eq(user.firstName)
        expect(user_json["lastName"]).to eq(user.lastName)
        expect(user_json["role"]).to eq(user.role)

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

        it "requires a valid email address" do
          variables["input"].merge!("description" => "foo")

          expect {
            create_post
          }.not_to change(Post.all, :count)
          
          expect(errors).not_to be_nil
        end

        it "requires a password" do
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
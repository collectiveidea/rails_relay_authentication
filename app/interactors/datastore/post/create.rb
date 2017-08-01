module Datastore
  module Post
    class Create < Datastore::Create
      context_with Post::Context

      CreatePostSchema = Dry::Validation.Schema do
        required(:title, Types::Strict::String).filled
        required(:description, Types::Strict::String).filled
        required(:image, Types::Strict::String).filled
        required(:user_uuid, Types::UUID).filled
      end

      before do
        context.datastore = Datastore.posts
        context.schema = CreatePostSchema
        context.whitelist = %i(title description image user_uuid)
        context.record_builder = Post::Build
      end
    end
  end
end
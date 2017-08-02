module Datastore
  module Post
    class Update < Datastore::Update
      context_with Post::Context

      UpdatePostSchema = Dry::Validation.Schema do
        optional(:title, Types::Strict::String) { filled? > str? }
        optional(:description, Types::Strict::String) { filled? > str? }
        optional(:image, Types::Strict::String) { filled? > str? }
        optional(:user_uuid, Types::UUID) { filled? & format?(Types::UUID_NORMALIZED_REGEXP) }
      end

      before do
        context.schema = UpdatePostSchema
        context.whitelist = %i(title description image user_uuid)
        context.datastore = Datastore.posts
        context.record_builder = Post::Build
      end
    end
  end
end
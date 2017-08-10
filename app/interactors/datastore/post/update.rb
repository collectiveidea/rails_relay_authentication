module Datastore
  module Post
    class Update < Datastore::Update
      context_with Post::Context

      UpdatePostSchema = Dry::Validation.Schema do
        optional(:title, Types::Strict::String) { filled? > str? }
        optional(:description, Types::Strict::String) { filled? > str? }
        optional(:image, Types::Strict::String) { filled? > str? }
        optional(:user_id, Types::Strict::String) { filled? > str? }
      end

      before do
        context.schema = UpdatePostSchema
        context.whitelist = %i(title description image user_id)
        context.datastore = Datastore.posts
        context.record_builder = Post::Build
      end
    end
  end
end
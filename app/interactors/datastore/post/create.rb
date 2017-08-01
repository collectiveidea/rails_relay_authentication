module Datastore
  module Post
    class Create
      include Interactor
      attr_accessor :error

      context_with Post::Context

      CreatePostSchema = Dry::Validation.Schema do
        required(:title, Types::Strict::String).filled
        required(:description, Types::Strict::String).filled
        required(:image, Types::Strict::String).filled
        required(:user_uuid, Types::UUID).filled
      end

      before do
        context.schema = CreatePostSchema
        context.whitelist = %i(title description image user_uuid)
      end

      def call
        build_post = Post::Build.call(context)
        if build_post.success?
          validate_post = Post::Validate.call(context)
          if validate_post.success?
            persist_post = Post::Persist.call(context)
            if persist_post.failure?
              error = persist_post.error
            end
          else
            error = validate_post.error
          end
        else
          error = build_post.error
        end
        context.fail!(error: error) if error
      end
    end
  end
end
class Post
  class Create
    include Interactor
    attr_accessor :error

    context_with Post::Context

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
      context.error = GraphQL::ExecutionError.new(error) if error
    end
  end
end
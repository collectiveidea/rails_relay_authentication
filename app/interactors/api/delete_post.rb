module API 
  class DeletePost
    include Interactor

    class Context < API::Context
      inputs :id
    end
    context_with Context


    before do
      context.fail!(error: "id must be filled") unless context.id.present?
      begin
        Types::UUID[context.id]
      rescue Dry::Types::ConstraintError => exception
        context.fail!(error: exception.message)
      end
    end

    before do
      context.fail!(error: "Resource not found") unless post = API::Post.find(context.id)
      context.fail!(error: "Forbidden") unless post.authorize(context.viewer, :delete)
    end

    def call
      delete_post = Datastore::Post::Delete.call(uuid: context.id)
      if delete_post.failure?
        context.fail!(error: delete_post.error)
      end
    end
  end
end
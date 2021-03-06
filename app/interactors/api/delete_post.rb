module API 
  class DeletePost
    include Interactor

    context_with(
      Class.new(API::Context) do
        inputs :id
      end      
    )

    before do
      context.fail!(error: "id must be filled") unless context.id.present?
    end

    before do
      context.fail!(error: "Resource not found") unless post = API::Post.find(context.id)
      context.fail!(error: "Forbidden") unless post.authorize(context.viewer, :delete)
    end

    def call
      delete_post = Datastore::Post::Delete.call(id: context.id)
      if delete_post.failure?
        context.fail!(error: delete_post.error)
      end
    end
  end
end
module API 
  class DeletePost
    include Interactor

    before do
      context.fail!(error: "id must be filled") unless context.id.present?
      begin
        Types::UUID[context.id]
      rescue Dry::Types::ConstraintError => exception
        context.fail!(error: exception.message)
      end
    end

    def call
      delete_post = Datastore::Post::Delete.call(uuid: context.id)
      
      if delete_post.failure?
        context.fail!(error: delete_post.error)
      end
    end
  end
end
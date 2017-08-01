module Datastore
  module Post
    class Delete
      include Interactor

      context_with Post::Context

      def call
        Datastore.posts.where(params).delete
      end

      def params
        context.id ? { id: context.id } : { uuid: context.uuid }
      end
    end
  end
end
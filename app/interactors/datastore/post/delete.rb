module Datastore
  module Post
    class Delete
      include Interactor

      def call
        Datastore.posts.where(params).delete
      end

      def params
        context.id ? { id: context.id } : { uuid: context.uuid }
      end
    end
  end
end
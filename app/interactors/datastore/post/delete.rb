module Datastore
  module Post
    class Delete
      include Interactor

      def call
        Datastore.posts.where(id: context.id).delete
      end
    end
  end
end
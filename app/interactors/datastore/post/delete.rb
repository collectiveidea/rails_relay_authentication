module Datastore
  module Post
    class Delete
      include Interactor
      delegate :datastore, to: :context

      before do
        context.datastore = Datastore.posts
      end

      def call
        datastore.delete(id: context.id)
      end
    end
  end
end
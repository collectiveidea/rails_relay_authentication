module Datastore
  module Post
    class Persist
      include Interactor  
 
      delegate :datastore, :datastore_action, to: :context

      context_with Post::Context

      def call
        # Should delegate datastore to context & datastore = Datastore.posts. Same with schema & whitelist
        context.id = datastore.send(datastore_action, context.params)
        context.record[:uuid] = datastore[id: context.id][:uuid]
      end
    end
  end
end
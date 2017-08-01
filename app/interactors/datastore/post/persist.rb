module Datastore
  module Post
    class Persist
      include Interactor  
      
      WHITELIST = %i(title description image)

      context_with Post::Context

      def call
        # Should delegate datastore to context & datastore = Datastore.posts. Same with schema & whitelist
        context.id = Datastore.posts.insert(context.record)
        context.record[:uuid] = Datastore.posts[id: context.id][:uuid]
      end

      def params
        context.record.slice(*WHITELIST)
      end
    end
  end
end
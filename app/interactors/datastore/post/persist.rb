module Datastore
  module Post
    class Persist
      include Interactor  
      
      context_with Post::Context

      def call
        context.id = Datastore.posts.insert(context.as_new_record)
        context.uuid = Datastore.posts[id: context.id][:uuid]
      end
    end
  end
end
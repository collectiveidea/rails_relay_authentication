module Datastore
  module Post
    class Persist
      include Interactor  
      
      context_with Post::Context

      def call
        context.id = Sequel::Model.db[:posts].insert(context.as_record)
        context.uuid = Sequel::Model.db[:posts][id: context.id][:uuid]
      end
    end
  end
end
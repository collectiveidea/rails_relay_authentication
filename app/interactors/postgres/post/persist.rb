module Postgres
  class Post
    class Persist
      include Interactor  
      
      context_with Post::Context

      def call
        context.id = Sequel::Model.db[:posts].insert(context.as_record)
      end
    end
  end
end
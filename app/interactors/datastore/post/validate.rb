module Datastore
  module Post
    class Validate
      include Interactor  
    
      context_with Post::Context

      def call
        result = Datastore::PostSchema.call(context.full_attributes)

        context.fail!(error: result.errors) if result.failure?
      end
    end
  end
end
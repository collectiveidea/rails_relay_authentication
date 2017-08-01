module Datastore
  module Post
    class Build
      include Interactor

      context_with Post::Context
      
      def call
        context.record = context.supplied_attributes
      end
    end
  end
end
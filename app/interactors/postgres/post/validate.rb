module Postgres
  module Post
    class Validate
      include Interactor

      context_with Post::Context
      
      def call
        # validations
      end
    end
  end
end
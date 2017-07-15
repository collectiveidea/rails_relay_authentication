module Postgres
  class Post
    class Validate
      include Interactor

      context_with Post::Context
      
      def call
        # validations
      end
    end
  end
end
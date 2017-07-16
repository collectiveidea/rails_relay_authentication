module Datastore
  module User
    class Validate
      include Interactor  
    
      context_with User::Context

      def call
        true
      end
    end
  end
end
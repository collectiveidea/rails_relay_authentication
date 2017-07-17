module Datastore
  module User
    class Validate
      include Interactor  
    
      context_with User::Context

      def call
        result = Datastore::UserSchema.call(context.as_record)
        context.fail!(error: result.errors) if result.failure?
      end
    end
  end
end
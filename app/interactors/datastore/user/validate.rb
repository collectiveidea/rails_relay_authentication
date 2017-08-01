module Datastore
  module User
    class Validate
      include Interactor  
    
      context_with User::Context

      def call
        validate_record = Datastore::UserSchema.call(context.record)
        context.fail!(error: validate_record.errors) if validate_record.failure?
      end
    end
  end
end
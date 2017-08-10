module Datastore
  module PasswordReset
    class Delete
      include Interactor  
      
      def call
        context.id = Datastore.password_resets.delete(token: context.token)
      end
    end
  end
end
module Datastore
  module PasswordReset
    class Delete
      include Interactor  
      
      def call
        context.id = Datastore.password_resets.where(token: context.token).delete
      end
    end
  end
end
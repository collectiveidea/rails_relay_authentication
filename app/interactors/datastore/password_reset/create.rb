module Datastore
  module PasswordReset
    class Create
      include Interactor  
      
      def call
        context.token = SecureRandom.base64(16)
        context.id = Datastore.password_resets.insert(
          user_uuid: context.user_uuid,
          token: context.token                              
        )
      end
    end
  end
end
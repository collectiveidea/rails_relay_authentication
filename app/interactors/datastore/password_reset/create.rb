module Datastore
  module PasswordReset
    class Create
      include Interactor  
      
      before do
        # Clear out any existing password resets for this user
        Datastore.password_resets.where(user_uuid: context.user_uuid).delete
      end

      def call
        context.token = SecureRandom.urlsafe_base64(24)
        context.id = Datastore.password_resets.insert(
          user_uuid: context.user_uuid,
          token: context.token                              
        )
      end
    end
  end
end
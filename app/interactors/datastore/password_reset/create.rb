module Datastore
  module PasswordReset
    class Create
      include Interactor

      delegate :datastore, to: :context

      before do
        context.datastore = Datastore.password_resets
      end
      
      before do
        # Clear out any existing password resets for this user
        datastore.where(user_id: context.user_id).delete
      end

      def call
        context.token = SecureRandom.urlsafe_base64(24)
        context.id = datastore.insert(
          user_id: context.user_id,
          token: context.token                              
        )[:id]
      end
    end
  end
end
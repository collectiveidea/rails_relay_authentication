module API
  class ResetPassword
    include Interactor

    context_with(
      Class.new(API::Context) do 
        inputs :newPassword, :token
        outputs :user
      end      
    )

    before do
      context.fail!(error: "Forbidden") if context.viewer.try(:is_logged_in)
    end
    
    def call
      context.fail!(error: "New password required") unless new_password = context.newPassword.presence
      context.fail!(error: "Password reset token required") unless context.token.present?
      context.fail!(error: "Token not found") unless password_reset = API::PasswordReset.find_by_token(context.token)
      context.fail!(error: "Token expired") unless password_reset.expires_at >= Time.current

      update_user = Datastore::User::Update.call(
        API::User.to_datastore(
          id: password_reset.user_id,
          password: new_password
        )
      )

      if update_user.success?
        Datastore::PasswordReset::Delete.call(token: password_reset.token)
        context.user = API::User.find(password_reset.user_id)
      else
        context.fail!(error: update_user.error)
      end
    end
  end
end
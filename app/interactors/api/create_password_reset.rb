module API
  class CreatePasswordReset
    include Interactor

    context_with(
      Class.new(API::Context) do
        inputs :email, :token
      end      
    )

    before do
      context.fail!(error: "Forbidden") if context.viewer.try(:is_logged_in)
    end

    def call
      context.fail!(error: "User not found") unless user = API::User.find_by_email(context.email)
      create_password_reset = Datastore::PasswordReset::Create.call(
        API::PasswordReset.to_datastore(user_id: user.id)
      )
      
      if create_password_reset.success?
        context.token = create_password_reset.token

        # Send email with token, 
        #   i.e. Email::PasswordReset::Create.call(to: user.email, token: context.token)
        Rails.logger.debug("Sending token #{context.token} to #{user.email}")
      else
        context.fail!(error: create_password_reset.error)
      end
    end
  end
end
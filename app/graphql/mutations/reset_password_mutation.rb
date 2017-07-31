Mutations::ResetPasswordMutation = GraphQL::Relay::Mutation.define do
  name  'ResetPassword'

  input_field :newPassword, !types.String
  input_field :token, !types.String

  return_field :user, Types::UserType

  resolve ->(object, inputs, ctx) {
    # Validate that the link is not expired
    # Update the user's password
    # Delete the corresponding password_reset record

    reset_password = API::ResetPassword.call(
      viewer: ctx[:viewer],
      newPassword: inputs[:newPassword],
      token: inputs[:token]
    )

    if reset_password.success?
      { user: reset_password.user }
    else
      GraphQL::ExecutionError.new(reset_password.error)
    end
  }
end

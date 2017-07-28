Mutations::CreatePasswordResetMutation = GraphQL::Relay::Mutation.define do
  name  'CreatePasswordReset'

  input_field :email, !types.String

  return_field :user, Types::UserType

  resolve ->(object, inputs, ctx) {
    create_password_reset = API::CreatePasswordReset.call(email: inputs[:email])

    if create_password_reset.success?
      { user: nil }
    else
      GraphQL::ExecutionError.new(create_password_reset.error)
    end
  }
end

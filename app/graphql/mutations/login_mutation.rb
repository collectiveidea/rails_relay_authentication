Mutations::LoginMutation = GraphQL::Relay::Mutation.define do
  # Used to name derived types, eg `"AddFeatureInput"`:
  name  'Login'

  # Accessible from `inputs` in the resolve function:
  input_field :email, !types.String
  input_field :password, !types.String

  return_field :user, Types::UserType

  resolve ->(object, inputs, ctx) {
    Rails.logger.debug "### LoginMutation.resolve #{inputs[:email]} #{inputs[:password]}"
    user = User.find_by(email: inputs[:email])

    if user && user.authenticate(inputs[:password])
      ctx[:request].env['warden'].set_user(user)
    end

    { user: user }
  }
end

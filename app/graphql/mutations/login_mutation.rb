Mutations::LoginMutation = GraphQL::Relay::Mutation.define do
  # Used to name derived types, eg `"AddFeatureInput"`:
  name  'Login'

  # Accessible from `inputs` in the resolve function:
  input_field :email, !types.String
  input_field :password, !types.String

  return_field :user, Types::UserType

  resolve ->(object, inputs, ctx) {
    user = User.find_by(email: inputs[:email])

    if user && user.authenticate(inputs[:password])
      ctx[:warden].set_user(user)
      { user: user }
    else
      GraphQL::ExecutionError.new("Wrong email or password")
    end
  }
end

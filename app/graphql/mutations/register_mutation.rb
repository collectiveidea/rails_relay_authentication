Mutations::RegisterMutation = GraphQL::Relay::Mutation.define do
  name  'Register'

  # Accessible from `inputs` in the resolve function:
  input_field :email, !types.String
  input_field :password, !types.String
  input_field :firstName, !types.String
  input_field :lastName, !types.String

  return_field :user, Types::UserType

  resolve ->(object, inputs, ctx) {
    existing_user = API::User.find_by(email: inputs[:email])
    
    if existing_user
      GraphQL::ExecutionError.new("Email already taken")
    else
      register = API::Register.call(inputs)

      if register.success?
        ctx[:warden].set_user(register.user)
        { user: register.user }
      else
        GraphQL::ExecutionError.new(register.error)
      end
    end
  }
end

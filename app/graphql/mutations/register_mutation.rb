Mutations::RegisterMutation = GraphQL::Relay::Mutation.define do
  # Used to name derived types, eg `"AddFeatureInput"`:
  name  'Register'

  # Accessible from `inputs` in the resolve function:
  input_field :email, !types.String
  input_field :password, !types.String
  input_field :firstName, !types.String
  input_field :lastName, !types.String

  # The result has access to these fields,
  # resolve must return a hash with these keys.
  # On the client-side this would be configured
  # as RANGE_ADD mutation, so our returned fields
  # must conform to that API.
  #return_field :featuresConnection, Types::FeatureType.connection_type
  return_field :user, Types::UserType

  resolve ->(object, inputs, ctx) {
    existing_user = User.find_by(email: inputs[:email])
    
    if existing_user
      GraphQL::ExecutionError.new("Email already taken")
    else
      create_user = API::Register.call(inputs)

      if create_user.success?
        { user: create_user.user }
      else
        GraphQL::ExecutionError.new(create_user.error)
      end
    end
  }
end

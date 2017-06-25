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
    Database.db.create_user(inputs)
  }
end

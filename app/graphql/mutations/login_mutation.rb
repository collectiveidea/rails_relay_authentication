Mutations::LoginMutation = GraphQL::Relay::Mutation.define do
  # Used to name derived types, eg `"AddFeatureInput"`:
  name  'Register'

  # Accessible from `inputs` in the resolve function:
  input_field :email, !types.String
  input_field :password, !types.String

  return_field :user, Types::UserType

  resolve ->(object, inputs, ctx) {
    Database.db.create_user(inputs)
  }
end

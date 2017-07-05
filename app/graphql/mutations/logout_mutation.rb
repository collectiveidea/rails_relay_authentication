Mutations::LogoutMutation = GraphQL::Relay::Mutation.define do
  name  'Logout'

  return_field :user, Types::UserType

  resolve ->(object, inputs, ctx) {
    user = ctx[:request].env['warden'].user
    ctx[:request].env['warden'].logout
    { user: user }
  }
end

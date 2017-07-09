Mutations::LogoutMutation = GraphQL::Relay::Mutation.define do
  name  'Logout'

  return_field :user, Types::UserType

  resolve ->(object, inputs, ctx) {
    ctx[:warden].logout
    { user: ctx[:viewer].user }
  }
end

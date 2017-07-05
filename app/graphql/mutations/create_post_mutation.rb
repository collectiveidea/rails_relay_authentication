Mutations::CreatePostMutation = GraphQL::Relay::Mutation.define do
  name  'CreatePost'

  input_field :title, !types.String
  input_field :description, !types.String
  input_field :image, !types.String

  return_field :postEdge, Types::PostType.connection_type
  return_field :user, Types::UserType
  
  resolve ->(object, inputs, ctx) {
    user = ctx[:request].env['warden'].user
    ctx[:request].env['warden'].logout
    { user: user }
  }
end

Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"
  field :register, field: Mutations::RegisterMutation.field
  field :login, field: Mutations::LoginMutation.field
  #field :logout, Mutations::LogoutMutation
  #field :createPost, Mutations::CreatePostMutation
end
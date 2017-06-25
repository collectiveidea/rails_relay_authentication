Types::QueryType = GraphQL::ObjectType.define do
  name "Mutation"
  field :register, Types::RegisterMutation
  field :login, Types::LoginMutation
  field :logout, Types::LogoutMutation
  field :createPost, Types::CreatePostMutation
end
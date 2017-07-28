Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"
  field :register, field: Mutations::RegisterMutation.field
  field :login, field: Mutations::LoginMutation.field
  field :createPasswordReset, field: Mutations::CreatePasswordResetMutation.field
  field :resetPassword, field: Mutations::ResetPasswordMutation.field
  field :logout, field: Mutations::LogoutMutation.field
  field :createPost, field: Mutations::CreatePostMutation.field
end
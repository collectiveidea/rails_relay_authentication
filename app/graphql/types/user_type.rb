Types::UserType = GraphQL::ObjectType.define do
  name "User"
  global_id_field :id

  field :id, types.ID do
    resolve ->(user, args, ctx) {
      user.uuid
    }
  end
  field :email, types.String, "the users email address"
  field :firstName, types.String, "the users first name"
  field :lastName, types. String, "the users last name"
  field :role, types.String, "the users role"
  connection :posts, Types::PostType.connection_type do
    argument :first, types.Int
    resolve ->(user, args, ctx) {
      user.posts
    }
  end
end
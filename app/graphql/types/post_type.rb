Types::PostType = GraphQL::ObjectType.define do
  name "Post"
  description "A post"
  global_id_field :id
  
  field :id, !types.ID do
    resolve ->(user, args, ctx) {
      user.uuid
    }
  end
  field :creator, Types::UserType do
    description "The posts creators"
    resolve ->(post, args, ctx) {
      post.user
    }
  end
  field :title, types.String, "The posts title"
  field :image, types.String, "The posts image"
  field :description, types.String, "The posts description"

  implements GraphQL::Relay::Node.interface
end
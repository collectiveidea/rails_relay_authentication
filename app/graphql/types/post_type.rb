Types::PostType = GraphQL::ObjectType.define do
  name "Post"
  description "A post"
  global_id_field :id
  
  field :id, !types.ID do
    resolve ->(post, args, ctx) {
      post.uuid
    }
  end
  field :creator, Types::UserType, "The posts creators"
  field :title, types.String, "The posts title"
  field :image, types.String, "The posts image"
  field :description, types.String, "The posts description"

  implements GraphQL::Relay::Node.interface
end
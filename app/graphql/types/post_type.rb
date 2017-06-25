Types::QueryType = GraphQL::ObjectType.define do
  name "Post"
  description "A post"
  field :id, types.ID
  field :creator, Types::UserType do
    description "The posts creators"
    resolve ->(post, args, ctx) {
      Database.db.get_post_creator(post)
    }
  end
  field :title, types.String, "The posts title"
  field :image, types.String, "The posts image"
  field :description, types.String, "The posts description"
end
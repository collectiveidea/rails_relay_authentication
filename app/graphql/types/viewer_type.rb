Types::ViewerType = GraphQL::ObjectType.define do
  name "Viewer"

  field :isLoggedIn, types.Boolean
  field :canPublish, types.Boolean 
  field :user, Types::UserType

  field :post, Types::PostType do
    argument :postId, types.String
    resolve ->(obj, args, ctx) {
      Post.find_by(uuid: args[:postId])
    }
  end

  connection :posts, Types::PostType.connection_type do
    argument :first, types.Int
    
    resolve ->(obj, args, ctx) {
      Post.all
    }
  end
end

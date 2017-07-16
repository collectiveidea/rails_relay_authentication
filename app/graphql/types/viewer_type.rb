Types::ViewerType = GraphQL::ObjectType.define do
  name "Viewer"

  field :isLoggedIn, types.Boolean
  field :canPublish, types.Boolean 
  field :user, Types::UserType

  field :post, Types::PostType do
    argument :postId, types.String
    resolve ->(obj, args, ctx) {
      API::Post.find(args[:postId])
    }
  end

  connection :posts, Types::PostType.connection_type do
    argument :first, types.Int
    
    resolve ->(obj, args, ctx) {
      API::Post.all
    }
  end
end

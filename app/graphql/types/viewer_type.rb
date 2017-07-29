Types::ViewerType = GraphQL::ObjectType.define do
  name "Viewer"

  field :isLoggedIn, types.Boolean do
    resolve ->(obj, args, ctx) {
      obj.is_logged_in
    }
  end

  field :canPublish, types.Boolean do
    resolve ->(obj, args, ctx) {
      obj.can_publish
    }    
  end

  field :user, Types::UserType

  field :post, Types::PostType do
    argument :postId, types.String
    resolve ->(obj, args, ctx) {
      API::Post.find(args[:postId])
    }
  end

  connection :posts, Types::PostType.connection_type do
    argument :first, types.Int
    argument :after, types.String
    
    resolve ->(obj, args, ctx) {
      API::Post.all
    }
  end
end

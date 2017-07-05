Types::ViewerType = GraphQL::ObjectType.define do
  name "Viewer"

  field :isLoggedIn, types.Boolean do
    resolve ->(obj, args, ctx) {
      ctx[:user] && ctx[:user].role.in?(User.roles.keys)      
    }
  end

  field :canPublish, types.Boolean do
    resolve ->(obj, args, ctx) {
      ctx[:user] && ctx[:user].role.in?(User.roles.keys[0..1])      
    }
  end

  field :user, Types::UserType do
    resolve ->(obj, args, ctx) {
      ctx[:user].presence      
    }
  end

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

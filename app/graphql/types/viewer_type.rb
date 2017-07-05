Types::ViewerType = GraphQL::ObjectType.define do
  name "Viewer"

  field :isLoggedIn, types.Boolean do
    resolve ->(obj, args, ctx) {
      ctx[:viewer] && ctx[:viewer].role.in?(User.roles.keys)      
    }
  end

  field :canPublish, types.Boolean do
    resolve ->(obj, args, ctx) {
      ctx[:viewer] && ctx[:viewer].role.in?(User.roles.keys[0..1])      
    }
  end

  field :user, Types::UserType do
    resolve ->(obj, args, ctx) {
      ctx[:viewer].presence      
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

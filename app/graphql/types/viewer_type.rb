Types::QueryType = GraphQL::ObjectType.define do
  name "Viewer"

  field :isLoggedIn, types.Boolean do
    resolve ->(obj, args, ctx) {
      ctx.tokenData[:role].in?(User.roles)      
    }
  end

  field :canPublish, types.Boolean do
    resolve ->(obj, args, ctx) {
      ctx.tokenData.role.in?(User.roles[0..1])      
    }
  end

  field :user, Types::UserType do
    resolve ->(obj, args, ctx) {
      Database.db.get_user(ctx.tokenData[:user_id])      
    }
  end

  field :posts, Types::PostType.connection_type do
    argument :first, types.Int
    resolve ->(obj, args, ctx) {
      Database.db.get_posts
    }
  end

  field :post, Types::PostType do
    argument :postId, types.String
    resolve ->(obj, args, ctx) {
      Database.db.get_post(args[:postId])      
    }
  end
end

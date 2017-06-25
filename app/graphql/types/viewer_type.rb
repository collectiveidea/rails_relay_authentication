Types::QueryType = GraphQL::ObjectType.define do
  name "Viewer"

  field :isLoggedIn, types.Boolean do
    resolve ->(obj, args, ctx) { }
  end
end

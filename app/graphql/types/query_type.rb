Types::QueryType = GraphQL::ObjectType.define do
  name "Root"

  field :viewer, Types::ViewerType do
    resolve ->(obj, args, ctx) { ctx[:viewer] }
  end
end

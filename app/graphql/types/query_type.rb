Types::QueryType = GraphQL::ObjectType.define do
  name "Root"

  # Used by Relay to lookup objects by UUID:
  field :node, GraphQL::Relay::Node.field

  # Fetches a list of objects given a list of IDs
  field :nodes, GraphQL::Relay::Node.plural_field

  field :viewer, Types::ViewerType do
    # This to return some sort of value. What it is doesn't
    #   really matter.
    resolve ->(obj, args, ctx) { true }
  end
end

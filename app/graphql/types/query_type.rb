Types::QueryType = GraphQL::ObjectType.define do
  name "Root"

  # Used by Relay to lookup objects by UUID:
  field :node, GraphQL::Relay::Node.field

  # Fetches a list of objects given a list of IDs
  field :nodes, GraphQL::Relay::Node.plural_field

  field :viewer, Types::ViewerType do
    resolve ->(obj, args, ctx) { Rails.logger.debug("### Resolving Root.viewer: #{obj} | #{args} | #{ctx}") }
  end
end

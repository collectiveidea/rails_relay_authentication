RailsRelayAuthenticationSchema = GraphQL::Schema.define do
  query(Types::QueryType)
  mutation(Types::MutationType)
end

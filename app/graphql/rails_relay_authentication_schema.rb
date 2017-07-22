RailsRelayAuthenticationSchema = GraphQL::Schema.define do
  query(Types::QueryType)
  mutation(Types::MutationType)

  id_from_object ->(object, type_definition, query_ctx) {
    # Call your application's UUID method here
    # It should return a string
    GraphQL::Schema::UniqueWithinType.encode(type_definition.name, object.uuid)
  }

  object_from_id ->(id, query_ctx) {
    class_name, id = GraphQL::Schema::UniqueWithinType.decode(id)

    "API::#{class_name.classify}".constantize.find(id)
  }

  resolve_type ->(obj, ctx) {
    case obj
    when API::Viewer
      Types::ViewerType
    when API::User
      Types::UserType
    when API::Post
      Types::PostType
    else
      raise("Unexpected object: #{obj}")
    end
  }
end

RailsRelayAuthenticationSchema = GraphQL::Schema.define do
  query(Types::QueryType)
  mutation(Types::MutationType)

  id_from_object ->(object, type_definition, query_ctx) {
    # Call your application's UUID method here
    # It should return a string
    GraphQL::Schema::UniqueWithinType.encode(type_definition.name, object.uuid)
  }

  object_from_id ->(id, query_ctx) {
    class_name, uuid = GraphQL::Schema::UniqueWithinType.decode(id)

    class_name.classify.find_by(uuid: uuid)
  }

  resolve_type ->(obj, ctx) {
    case obj
    when User
      Types::UserType
    when Post
      Types::PostType
    else
      raise("Unexpected object: #{obj}")
    end
  }
end

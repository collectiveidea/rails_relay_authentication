RailsRelayAuthenticationSchema = GraphQL::Schema.define do
  query(Types::QueryType)
  #mutation(Types::MutationType)

  id_from_object ->(object, type_definition, query_ctx) {
    # Call your application's UUID method here
    # It should return a string
    GraphQL::Schema::UniqueWithinType.encode(type_definition.name, object.id)
  }

  object_from_id ->(id, query_ctx) {
    type_name, item_id = GraphQL::Schema::UniqueWithinType.decode(id)

    Database.db.send("get_#{type_name}", item_id)
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

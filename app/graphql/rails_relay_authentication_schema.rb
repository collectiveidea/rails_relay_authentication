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

    #class_name.classify.find_by(uuid: uuid)

    # Translate to an intermediate object, then represent
    # as a GraphQL object
    user = Postgres::User.find_by(uuid: uuid)
    API::User::Decorate.call(user.to_h)
  }

  resolve_type ->(obj, ctx) {
    case obj
    when DecoratedViewer
      Types::ViewerType
    when DecoratedUser
      Types::UserType
    when DecoratedPost
      Types::PostType
    else
      raise("Unexpected object: #{obj}")
    end
  }
end

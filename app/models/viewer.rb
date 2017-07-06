class Viewer < Dry::Struct
  constructor :schema

  attribute :uuid, Types::UUID.optional.default(nil)
  attribute :role, Types::Role.optional.default(nil)

  def canPublish
    role.in?(User.publisher_roles)
  end

  def isLoggedIn
    !!(role && uuid)
  end

  def user
    @user ||= User.find_by(uuid: uuid)
  end

  def attributes
    to_hash.stringify_keys
  end
end
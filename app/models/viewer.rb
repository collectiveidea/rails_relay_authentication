class Viewer < Dry::Struct
  constructor :schema

  attribute :id, Types::UUID.optional.default(nil)
  attribute :role, Types::Role.optional.default(nil)

  def can_publish
    role.in?(User.publisher_roles)
  end

  def is_logged_in
    !!(role && uuid)
  end

  def user
    @user ||= User.get(id)
  end
end
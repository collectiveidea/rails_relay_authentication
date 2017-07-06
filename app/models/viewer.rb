class Viewer < Dry::Struct
  include CamelizeAttributes

  camelize_attributes :can_publish, :is_logged_in

  constructor :schema

  attribute :uuid, Types::UUID.optional.default(nil)
  attribute :role, Types::Role.optional.default(nil)

  def can_publish
    role.in?(User.publisher_roles)
  end

  def is_logged_in
    !!(role && uuid)
  end

  def user
    @user ||= User.find_by(uuid: uuid)
  end
end
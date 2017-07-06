# This object is designed to quack like a User, but it's a fast, lightweight object
#   that can easily be deserialized on every request without hitting the db unless
#   it's absolutely necessary.
class Viewer < Dry::Struct
  attribute :uuid, Types::UUID
  attribute :email, Types::String
  attribute :role, Types::Role
  attribute :first_name, Types::String.optional
  attribute :last_name, Types::String.optional
  attribute :authentication_token, Types::String.optional

  def posts
    user.posts
  end

  def can_publish?
    role.in?(User.roles.keys[0..1])
  end

  alias_method :firstName, :first_name
  alias_method :lastName, :last_name

  private

  def user
    @user ||= User.find_by(authentication_token: authentication_token)
  end
end
class Viewer < Dry::Struct
  attribute :uuid, Types::UUID
  attribute :role, Types::Role

  delegate_missing_to :user

  def can_publish?
    role.in?(User.roles.keys[0..1])
  end

  private

  def user
    @user ||= User.find_by(uuid: uuid)
  end
end
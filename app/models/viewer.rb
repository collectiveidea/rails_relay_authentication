class Viewer < Dry::Struct
  attribute :uuid, Types::UUID
  attribute :email, Types::String
  attribute :role, Types::Role
  attribute :first_name, Types::String.optional
  attribute :last_name, Types::String.optional
  attribute :authentication_token, Types::String.optional

  def posts
    Post.where(user_id: id)
  end

  alias_method :firstName, :first_name
  alias_method :lastName, :last_name

  private 

  def id
    @id ||= User.where(uuid: uuid).limit(1).pluck(:id).first
  end
end
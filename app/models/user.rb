class User < ApplicationRecord
  attribute :id, Types::Int
  attribute :first_name, Types::String
  attribute :last_name, Types::String
  attribute :email, Types::String
  attribute :role, Types::Int
  attribute :password_digest, Types::String

  camelize_attributes :first_name, :last_name

  def posts
    DB[:posts].where(user_id: id)
  end

  def self.publisher_roles
    roles.keys[0..1]
  end
end
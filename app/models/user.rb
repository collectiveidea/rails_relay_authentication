class User < Dry::Struct
  include UserDatastore
  include UserAPI

  ROLES = { "reader" => 0, "publisher" => 1, "admin" => 2 }

  constructor :schema

  attribute :id, Types::UUID
  attribute :email, Types::Email
  attribute :role, Types::Strict::String
  attribute :password_digest, Types::Strict::String.optional
  attribute :password, Types::Strict::String.optional
  attribute :authentication_token, Types::Strict::String.optional
  attribute :first_name, Types::Strict::String.optional
  attribute :last_name, Types::Strict::String.optional

  def self.publisher_roles
    ROLES.keys[1..2]
  end
end
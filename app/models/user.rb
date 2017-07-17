class User < Dry::Struct
  include UserDatastore
  include UserAPI

  constructor :schema

  attribute :id, Types::UUID.optional
  attribute :email, Types::Email.optional
  attribute :role, Types::Strict::String.optional
  attribute :password_digest, Types::Strict::String.optional
  attribute :password, Types::Strict::String.optional
  attribute :authentication_token, Types::Strict::String.optional
  attribute :first_name, Types::Strict::String.optional
  attribute :last_name, Types::Strict::String.optional

  ROLES = { "reader" => 0, "publisher" => 1, "admin" => 2 }

  def self.publisher_roles
    ROLES.keys[1..2]
  end
end
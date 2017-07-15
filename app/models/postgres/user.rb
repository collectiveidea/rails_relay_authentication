class User < Dry::Struct
  attribute :email, Strict::String
  attribute :id, Strict::Int
  attribute :uuid, Types::UUID
  attribute :role, Strict::Int
  attribute :password_digest, Strict::String
  attribute :authentication_token, Strict::String.optional
  attribute :first_name, Strict::String.optional
  attribute :last_name, Strict::String.optional
end
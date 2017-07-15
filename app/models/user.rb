class User < Dry::Struct
  constructor :schema

  attribute :email, Strict::String
  attribute :id, Types::UUID
  attribute :role, Strict::String
  attribute :password_digest, Strict::String
  attribute :authentication_token, Strict::String.optional
  attribute :first_name, Strict::String.optional
  attribute :last_name, Strict::String.optional

  def authenticate(password_string)
    return self if BCrypt::Password.new(password_digest) == password_string
  end

  def regenerate_authentication_token!
    #self[:authentication_token] = SecureRandom.base58(24)
  end

  def self.publisher_roles
    #ROLES.values[1..2]
  end
end
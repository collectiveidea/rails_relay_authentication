class User < Dry::Struct
  include UserPostgres
  include UserAPI

  constructor :schema

  attribute :email, Types::Email.optional
  attribute :id, Types::UUID.optional
  attribute :role, Types::Strict::String.optional
  attribute :password_digest, Types::Strict::String.optional
  attribute :authentication_token, Types::Strict::String.optional
  attribute :first_name, Types::Strict::String.optional
  attribute :last_name, Types::Strict::String.optional

  ROLES = { "reader" => 0, "publisher" => 1, "admin" => 2 }

  def regenerate_authentication_token!
    #self[:authentication_token] = SecureRandom.base58(24)
  end

  def self.publisher_roles
    ROLES.values[1..2]
  end

  def self.find(attrs)
    if interface = attrs[:interface].try(:to_s)
      # Translate to standard system user representation
      user = User.from(interface, attrs)

      # Find the user in the datastore and load attributes
      db_user = Postgres::User.load(user)

      # Translate back to interface user representation
      interface.classify.constantize::User.new(creator.to(interface))
    else
      user = Postgres::User.find(attrs)

      # Translate back to interface user representation
      interface.classify.constantize::User.new(creator.to(interface))
    end
  end
end
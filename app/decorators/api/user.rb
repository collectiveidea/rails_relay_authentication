module API
  class User < Dry::Struct
    constructor :schema

    attribute :id, Types::UUID
    attribute :email, Types::Strict::String
    attribute :firstName, Types::Strict::String.optional
    attribute :lastName, Types::Strict::String.optional
    attribute :authentication_token, Types::Strict::String.optional
    attribute :password_digest, Types::Strict::String
    attribute :role, Types::Role

    def authenticate(password_string)
      return self if BCrypt::Password.new(password_digest) == password_string
    end

    def posts
      API::Post.by_user(id)
    end

    def self.find(id)
      user_attrs = ::User.find(id).to_api
      API::User.new(user_attrs)
    end
  end
end
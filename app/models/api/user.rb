module API
  class User < Dry::Struct
    constructor :schema

    attribute :id, Types::Strict::String.optional
    attribute :email, Types::Strict::String.optional
    attribute :firstName, Types::Strict::String.optional
    attribute :lastName, Types::Strict::String.optional
    attribute :authentication_token, Types::Strict::String.optional
    attribute :password_digest, Types::Strict::String.optional
    attribute :role, Types::Strict::String.optional

    def authenticate(password_string)
      return self if BCrypt::Password.new(password_digest) == password_string
    end

    def posts
      API::Post.by_user(id)
    end

    def self.find(id)
      return unless user = ::User.find(id)
      API::User.new(user.to_api)
    end

    def self.create(attrs)
      return unless user = ::User.create(attrs)
      new(user.to_api)
    end

    def self.find_by(params)
      return unless user = ::User.find_by(params)
      new(user.to_api)
    end
  end
end
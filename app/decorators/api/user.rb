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
      ::Post.by_user(id).map do |post|
        API::Post.new(post.to_api)
      end
    end
  end
end
module API
  class User < Dry::Struct
    constructor :schema

    attribute :id, Types::UUID
    attribute :email, Strict::String
    attribute :firstName, Strict::String.optional
    attribute :lastName, Strict::String.optional
    attribute :authentication_token, Strict::String.optional
    attribute :password_digest, Strict::String
    attribute :role, Types::Role

    def authenticate(password_string)
      return self if BCrypt::Password.new(password_digest) == password_string
    end

    def posts
      Postgres::Post.by_user(id).lazy.map do |post|
        API::Post.new(post.to_api)
      end
    end
  end
end
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
      Post.for_user(user_id, interface: :api)
      Postgres::Post.where(user_id: id).lazy.map do |post_attrs|
        post = Post.from_postgres(post_attrs)
        API::Post.new(post.to_api)
      end
    end
  end
end
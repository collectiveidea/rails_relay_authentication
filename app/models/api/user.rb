module API
  class User < Dry::Struct
    include DatastoreAdapter

    constructor :schema

    attribute :id, Types::Strict::String
    attribute :email, Types::Email
    attribute :role, Types::Role
    attribute :firstName, Types::Strict::String.optional
    attribute :lastName, Types::Strict::String.optional
    attribute :password_digest, Types::Strict::String.optional

    def authenticate(password_string)
      return self if BCrypt::Password.new(password_digest) == password_string
    end

    def posts
      API::Post.by_user(id)
    end

    module ClassMethods
      def find_by_email(email)
        find_by(email: email.downcase)
      end

      def publisher_roles
        Types::USER_ROLES.keys[1..2]
      end

      def to_datastore(attrs)
        Hash[
          attrs.map do |k, v|
            key = k.to_sym
            if key == :role
              [key, Types::USER_ROLES[v.to_s]]
            elsif key == :firstName
              [:first_name, v]
            elsif key == :lastName
              [:last_name, v]
            else
              [key, v]
            end
          end
        ]
      end

      def from_datastore(attrs={})
        attrs = attrs.symbolize_keys
        API::User.new(
          id:                   attrs[:id],
          firstName:            attrs[:first_name],
          lastName:             attrs[:last_name],
          email:                attrs[:email],
          role:                 attrs[:role] ? Types::USER_ROLES.keys[attrs[:role]] : nil,
          authentication_token: attrs[:authentication_token],
          password_digest:      attrs[:password_digest]
        )
      end
    end
    extend ClassMethods
  end
end
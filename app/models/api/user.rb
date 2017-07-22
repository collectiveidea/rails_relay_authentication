module API
  class User < Dry::Struct
    include DatastoreAdapter
    
    ROLES = { "reader" => 0, "publisher" => 1, "admin" => 2 }

    constructor :schema

    attribute :id, Types::UUID
    attribute :email, Types::Email
    attribute :role, Types::Role
    attribute :firstName, Types::Strict::String.optional
    attribute :lastName, Types::Strict::String.optional
    attribute :authentication_token, Types::Strict::String.optional
    attribute :password_digest, Types::Strict::String.optional

    def authenticate(password_string)
      return self if BCrypt::Password.new(password_digest) == password_string
    end

    def posts
      API::Post.by_user(id)
    end

    def regenerate_authentication_token!
      # Datastore::User::NewAuthToken.call(id: id).authentication_token
      # self[:authentication_token] = SecureRandom.base58(24)
    end

    module ClassMethods
      def publisher_roles
        ROLES.keys[1..2]
      end

      def to_datastore(attrs)
        Hash[
          attrs.map do |k, v|
            key = k.to_sym
            if key == :id
              [:uuid, v]
            elsif key == :role
              [key, User::ROLES[v.to_s]]
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
          id:                   attrs[:uuid],
          firstName:            attrs[:first_name],
          lastName:             attrs[:last_name],
          email:                attrs[:email],
          role:                 attrs[:role] ? User::ROLES.keys[attrs[:role]] : nil,
          authentication_token: attrs[:authentication_token],
          password_digest:      attrs[:password_digest]
        )
      end
    end
    extend ClassMethods
  end
end
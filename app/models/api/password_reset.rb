module API
  class PasswordReset < Dry::Struct
    include DatastoreAdapter

    constructor :schema

    attribute :user_id, Types::Strict::Int
    attribute :token, Types::Strict::String.constrained(min_size: 32)
    attribute :expires_at, Types::Strict::Time


    module ClassMethods
      def find_by_token(token)
        find_by(token: token)
      end

      def to_datastore(attrs)
        attrs
      end

      def from_datastore(attrs={})
        attrs = attrs.symbolize_keys
        API::PasswordReset.new(
          user_id: attrs[:user_id],
          token: attrs[:token],
          expires_at: attrs[:expires_at]
        )
      end
    end
    extend ClassMethods
  end
end
module API
  class PasswordReset < Dry::Struct
    include DatastoreAdapter

    constructor :schema

    attribute :user_id, Types::UUID
    attribute :token, Types::Strict::String
    attribute :expires_at, Types::Strict::Time


    module ClassMethods
      def find_by_token(token)
        find_by(token: token)
      end

      def to_datastore(attrs)
        Hash[
          attrs.map do |k, v|
            key = k.to_sym
            if key == :user_id
              [:user_uuid, v]
            else
              [key, v]
            end
          end
        ]
      end

      def from_datastore(attrs={})
        attrs = attrs.symbolize_keys
        API::PasswordReset.new(
          user_id: attrs[:user_uuid],
          token: attrs[:token],
          expires_at: attrs[:expires_at]
        )
      end
    end
    extend ClassMethods
  end
end
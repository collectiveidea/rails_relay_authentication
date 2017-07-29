module Datastore
  module User
    class Context < BaseContext
      def self.modifiable_attribute_names
        %i(email first_name last_name role password password_digest authentication_token)
      end

      attr_accessor *accessors

      def supplied_attributes
        if @keys.include?(:password)
          full_attributes.slice(*@keys).except(:password).merge(password_digest: password_digest)
        else
          full_attributes.slice(*@keys)
        end
      end
    end
  end
end
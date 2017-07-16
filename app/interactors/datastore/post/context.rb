module Datastore
  module Post
    class Context < BaseContext
      def self.accessors
        super + %i(title description image user_id)
      end

      attr_accessor *accessors
    end
  end
end
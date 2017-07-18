module Datastore
  module User
    module ClassMethods
      def where(params)
        table.where(params)
      end

      def find_by(params)
        where(params).first
      end

      def delete_all
        table.delete
      end

      def all
        table.to_a
      end

      def table
        Datastore.users
      end
    end
    extend ClassMethods
  end
end
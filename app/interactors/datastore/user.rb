module Datastore
  module User
    module ClassMethods
      def create(args)
        new_user_id = Datastore::User::Create.call(args).id
        find_by(id: new_user_id)
      end

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
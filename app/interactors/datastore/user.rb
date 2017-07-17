module Datastore
  module User
    module ClassMethods
      def create(args)
        create_user = Datastore::User::Create.call(args)
        if create_user.failure?
          create_user.as_record.merge(errors: create_user.error)
        else
          find_by(id: create_user.id)
        end
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
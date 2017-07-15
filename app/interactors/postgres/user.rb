module Postgres
  module User
    module ClassMethods
      def create(args)
        new_user_id = Postgres::User::Create.call(args).id
        table[new_user_id]
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

      def table
        Sequel::Model.db[:users]
      end
    end
    extend ClassMethods
  end
end
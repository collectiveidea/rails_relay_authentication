module Postgres
  module User
    module ClassMethods
      def where(params)
        table.where(params).map do |user_attrs|
          User.from_postgres(user_attrs)
        end
      end

      def find_by(params)
        user_attrs = where(params).first
        User.from_postgres(user_attrs)
      end

      def find(uuid)
        user_attrs = find_by(uuid: Types::UUID[uuid]) if uuid.present?
        User.from_postgres(user_attrs)
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
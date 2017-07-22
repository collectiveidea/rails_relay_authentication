module API
  module DatastoreAdapter
    extend ActiveSupport::Concern

    included do
      set_datastore_table self.name.split('::').last.pluralize.downcase.to_sym
    end

    module ClassMethods
      def set_datastore_table(table)
        @table = table
      end
      
      def find(uuid)
        find_by(uuid: Types::UUID[uuid]) if uuid.present?
      end

      def where(params)
        Datastore.where(@table, params).map do |record|
          from_datastore record
        end
      end

      def find_by(params)
        if record = Datastore.find_by(@table, params)
          from_datastore record
        end
      end

      def delete_all
        Datastore.delete_all(@table)
      end

      def all
        Datastore.all(@table).map do |record|
          from_datastore record
        end
      end

      def count
        Datastore.count(@table)
      end
    end
  end
end
module API
  module DatastoreAdapter
    extend ActiveSupport::Concern

    included do
      set_datastore_table self.name.split('::').last.pluralize.underscore.to_sym
    end

    module ClassMethods
      def set_datastore_table(table)
        @datastore = Datastore::Table.new(table)
      end
      
      def find(id)
        find_by(id: id) if id.present?
      end

      def find_by(params)
        if record = @datastore.find_by(params)
          from_datastore record
        end
      end

      def where(params)
        @datastore.where(params).map do |record|
          from_datastore record
        end
      end

      def delete_all
        @datastore.delete_all
      end

      def all
        @datastore.all.map do |record|
          from_datastore record
        end
      end

      def count
        @datastore.count
      end
    end
  end
end
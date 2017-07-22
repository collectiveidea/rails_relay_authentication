module API
  module DatastoreAdapter
    extend ActiveSupport::Concern

    included do
      set_datastore_class "Datastore::#{self.name.split('::').last}".constantize
    end

    module ClassMethods
      def set_datastore_class(klass)
        @datastore_class = klass
      end
      
      def find(uuid)
        find_by(uuid: Types::UUID[uuid]) if uuid.present?
      end

      def where(params)
        @datastore_class.where(params).map do |record|
          from_datastore record
        end
      end

      def find_by(params)
        if record = @datastore_class.find_by(params)
          from_datastore record
        end
      end

      def delete_all
        @datastore_class.delete_all
      end

      def all
        @datastore_class.all.map do |record|
          from_datastore record
        end
      end

      def count
        @datastore_class.count
      end

    end
  end
end
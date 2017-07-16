module Datastore
  module Post
    module ClassMethods
      def create(args)
        new_post_id = Datastore::Post::Create.call(args).id
        find_by(id: new_post_id)
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
        Sequel::Model.db[:posts]
      end
    end
    extend ClassMethods
  end
end
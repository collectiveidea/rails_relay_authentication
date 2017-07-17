module Datastore
  module Post
    module ClassMethods
      def create(args)
        create_post = Datastore::Post::Create.call(args)
        if create_post.failure?
          create_post.as_record.merge(errors: create_post.error)
        else
          find_by(id: create_post.id)
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
        Datastore.posts
      end
    end
    extend ClassMethods
  end
end
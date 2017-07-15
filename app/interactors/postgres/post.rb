module Postgres
  module Post
    module ClassMethods
      def by_user(user_id) 
        where(user_id: Types::UUID[user_id])
      end

      def where(params)
        table.where(params).map do |post_attrs|
          Post.from_postgres(post_attrs)
        end
      end

      def find_by(params)
        post_attrs = where(params).first
        Post.from_postgres(post_attrs)
      end

      def find(uuid)
        post_attrs = find_by(uuid: Types::UUID[uuid]) if uuid.present?
        Post.from_postgres(post_attrs)
      end

      def delete_all
        table.delete
      end

      def table
        Sequel::Model.db[:posts]
      end
    end
    extend ClassMethods
  end
end
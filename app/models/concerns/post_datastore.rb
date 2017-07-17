module PostDatastore
  extend ActiveSupport::Concern

  module ClassMethods
    def by_user(user_id) 
      where(user_id: Types::UUID[user_id])
    end
    
    def find(uuid)
      find_by(uuid: Types::UUID[uuid]) if uuid.present?
    end

    def where(params)
      Datastore::Post.where(params).map do |post_record|
        from_datastore post_record
      end
    end

    def find_by(params)
      if post = Datastore::Post.find_by(params)
        from_datastore post
      end
    end

    def delete_all
      Datastore::Post.delete_all
    end

    def all
      Datastore::Post.all.map do |post_record|
        from_datastore post_record
      end
    end

    def from_datastore(attrs={})
      attrs = attrs.symbolize_keys
      new(
        id: attrs[:uuid],
        title: attrs[:title],
        description: attrs[:description],
        image: attrs[:image],
        user_id: attrs[:user_id]
      )
    end
  end
end
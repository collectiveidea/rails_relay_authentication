module PostDatastore
  extend ActiveSupport::Concern

  module ClassMethods
    def by_user(user_id) 
      where(user_id: Types::UUID[user_id])
    end
    
    def find(uuid)
      find_by(uuid: Types::UUID[uuid]) if uuid.present?
    end

    def create(args)
      post_attrs = to_datastore(args)
      from_datastore Datastore::Post.create(post_attrs)
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

    def to_datastore(attrs)
      attrs.transform_keys do |k|
        key = k.to_sym
        if key == :id
          :uuid
        elsif key == :creatorId
          :user_id
        else
          key
        end
      end
    end

    def from_datastore(attrs={})
      new(
        id: attrs[:uuid] || attrs["uuid"],
        title: attrs[:title] || attrs["title"],
        description: attrs[:description] || attrs["description"],
        image: attrs[:image] || attrs["image"],
        user_id: attrs[:user_id] || attrs["user_id"]
      )
    end
  end
end
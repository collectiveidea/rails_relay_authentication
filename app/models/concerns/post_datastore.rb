module PostDatastore
  extend ActiveSupport::Concern

  def to_datastore
    {
      uuid: id,
      title: title,
      image: image,
      description: description,
      user_id: user_id
    }
  end

  module ClassMethods
    def by_user(user_id) 
      where(user_id: Types::UUID[user_id])
    end

    def attrs_for_datastore(attrs)
      new(attrs).to_datastore
    end
    
    def find(uuid)
      find_by(uuid: Types::UUID[uuid]) if uuid.present?
    end

    def create(args)
      post_attrs = attrs_for_datastore(args)
      from_datastore Datastore::Post.create(post_attrs)
    end

    def where(params)
      Datastore::Post.where(params).map do |post_record|
        from_datastore post_record
      end
    end

    def find_by(params)
      from_datastore Datastore::Post.find_by(params)
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
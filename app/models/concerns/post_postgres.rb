module PostPostgres
  extend ActiveSupport::Concern

  def to_postgres
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

    def attrs_for_postgres(attrs)
      new(attrs).to_postgres
    end
    
    def find(uuid)
      find_by(uuid: Types::UUID[uuid]) if uuid.present?
    end

    def create(args)
      post_attrs = attrs_for_postgres(args)
      from_postgres Postgres::Post.create(post_attrs)
    end

    def where(params)
      Postgres::Post.where(params).map do |post_record|
        from_postgres post_record
      end
    end

    def find_by(params)
      from_postgres Postgres::Post.find_by(params)
    end

    def delete_all
      Postgres::Post.delete_all
    end

    def from_postgres(attrs={})
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
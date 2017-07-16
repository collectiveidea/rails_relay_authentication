module API
  class Post < Dry::Struct
    constructor :schema

    attribute :id, Types::UUID
    attribute :creatorId, Types::UUID
    attribute :title, Types::Strict::String
    attribute :description, Types::Strict::String
    attribute :image, Types::Strict::String.optional

    def creator
      @creator ||= API::User.find(creatorId)
    end

    def self.by_user(id)
      ::Post.by_user(id).map do |post|
        API::Post.new(post.to_api)
      end
    end

    def self.create(attrs)
      post = ::Post.create(attrs)
      API::Post.new(post.to_api)
    end

    def self.all
      ::Post.all.map do |post|
        API::Post.new(post.to_api)
      end
    end

    def self.find(id)
      post = ::Post.find(id)
      API::Post.new(post.to_api)
    end
  end
end
module API
  class Post < Dry::Struct
    constructor :schema

    attribute :id, Types::UUID
    attribute :creatorId, Types::UUID
    attribute :title, Types::Strict::String.optional
    attribute :description, Types::Strict::String.optional
    attribute :image, Types::Strict::String.optional

    def creator
      @creator ||= API::User.find(creatorId)
    end

    def self.by_user(id)
      ::Post.by_user(id).map do |post|
        API::Post.new(post.to_api)
      end
    end

    def self.all
      ::Post.all.map do |post|
        API::Post.new(post.to_api)
      end
    end

    def self.find(id)
      return unless post = ::Post.find(id)
      API::Post.new(post.to_api)
    end
  end
end
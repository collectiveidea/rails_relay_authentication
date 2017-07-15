module API
  class Post < Dry::Struct
    constructor :schema

    attribute :id, Types::UUID
    attribute :creatorId, Types::UUID
    attribute :title, Types::Strict::String
    attribute :description, Types::Strict::String
    attribute :image, Types::Strict::String.optional

    def creator
      @creator ||= ::User.find_for_api(creatorId)
    end
  end
end
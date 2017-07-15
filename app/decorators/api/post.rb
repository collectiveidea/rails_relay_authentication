module API
  class Post < Dry::Struct
    constructor :schema

    attribute :id, Types::UUID
    attribute :creatorId, Types::UUID
    attribute :title, Strict::String
    attribute :description, Strict::String
    attribute :image, Strict::String.optional
  end

  def creator
    @creator ||= API::User.new(User.find(id).to_api)
  end
end
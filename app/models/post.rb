class Post < Dry::Struct
  include PostDatastore
  include PostAPI
  
  constructor :schema

  attribute :id, Types::UUID.optional
  attribute :user_id, Types::UUID.optional
  attribute :title, Types::Strict::String.optional
  attribute :description, Types::Strict::String.optional
  attribute :image, Types::Strict::String.optional
end
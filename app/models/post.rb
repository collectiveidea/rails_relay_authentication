class Post < Dry::Struct
  attribute :id, Types::UUID
  attribute :user_id, Types::UUID
  attribute :title, Strict::String
  attribute :description, Strict::String
  attribute :image, Strict::String
end
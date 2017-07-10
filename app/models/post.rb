class Post < ApplicationRecord
  #belongs_to :user

  attribute :id, Types::Int
  attribute :user_id, Types::Int
  attribute :title, Types::String
  attribute :image, Types::String
  attribute :description, Types::String

  def user
    @user ||= User.find_by(id: user_id)
  end

  alias_attribute :creator, :user
  alias_attribute :creator_id, :user_id
  camelize_attribute :creator_id
end
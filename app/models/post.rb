class Post < ApplicationRecord
  belongs_to :user

  alias_attribute :creator_id, :user_id
  camelize_attribute :creator_id
end
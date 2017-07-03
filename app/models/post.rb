class Post < ApplicationRecord
  belongs_to :user

  def creatorId
    user_id
  end

  def creatorId=(value)
    self[:user_id] = value
  end
end
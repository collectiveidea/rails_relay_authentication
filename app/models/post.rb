class Post < ApplicationRecord
  ATTRIBUTES = %i(id creator_id title image description)

  attr_accessor *ATTRIBUTES
  
  def initialize(args)
    @args = args
    args.each do |attr, value|
      self.send("#{attr}=", value)  
    end
  end

  def creatorId
    creator_id
  end

  def creatorId=(value)
    @creator_id = value
  end
end
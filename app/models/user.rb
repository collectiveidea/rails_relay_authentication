class User < ApplicationRecord
  enum role: [ :reader, :publisher, :admin ]

  has_many :posts

  has_secure_password
  has_secure_token :authentication_token

  def firstName
    first_name
  end
  
  def firstName=(value)
    self[:first_name] = value
  end

  def lastName
    last_name
  end
  
  def lastName=(value)
    self[:last_name] = value
  end

  def publisher_roles
    roles.keys[0..1]
  end
end
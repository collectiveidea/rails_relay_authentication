class User < ApplicationRecord
  has_many :posts

  has_secure_password
  has_secure_token :authentication_token

  enum role: [ :reader, :publisher, :admin ]

  camelize_attributes *column_names

  def self.publisher_roles
    roles.keys[0..1]
  end
end
class User < Sequel::Model
  include RecordHelpers

  one_to_many :posts

  ROLES = {
    "reader" => 0,
    "publisher" => 1,
    "admin" => 2            
  }

  def role
    ROLES.keys[super]
  end

  def role=(role_name)
    role_name = Types::Role["#{role_name}"]
    self[:role] = ROLES[role_name]
  end

  def password=(password_string)
    if password_string.present?
      password_string = Types::Password[password_string]
      self[:password_digest] = BCrypt::Password.create(password_string)
    end    
  end

  def email=(email_address)
    if email_address.present?
      self[:email] = Types::Email[email_address]
    end
  end

  def authenticate(password_string)
    return self if BCrypt::Password.new(password_digest) == password_string
  end

  def regenerate_authentication_token!
    self[:authentication_token] = SecureRandom.base58(24)
  end

  alias_method :firstName, :first_name
  alias_method :firstName=, :first_name=
  alias_method :lastName, :last_name
  alias_method :lastName=, :last_name=

  def self.publisher_roles
    ROLES.values[1..2]
  end
end
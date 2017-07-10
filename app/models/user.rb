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
    if role_name.present?
      self[:role] = ROLES["#{role_name}"]
    end
  end

  def password=(password_string)
    if password_string.present?
      self[:password_digest] = BCrypt::Password.create(password_string)
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
end
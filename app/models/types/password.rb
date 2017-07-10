module Types
  Password = Strict::String.constructor do |password|
    if password.present?
      BCrypt::Password.create(password)
    end
  end
end
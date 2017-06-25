module Authentication
  SECRET = ENV['SECRET_KEY_BASE'] || "secret_goes_here"

  def create_token(args = {})
    Rails.logger.debug("create token with user id #{args[:id]}")
    args[:id] && args[:role] && JWT.encode({ userId: args[:id], password: args[:password] }, SECRET)
  end

  def decode_token(token)
    JWT.decode(token, SECRET)
  end

  def is_logged_in?(role)
    # This needs access to a global in JS. Not sure how to handle this here
    $current_user.try(:role).in?(User.roles)
  end

  def can_publish?(role)
    role.in?(User.roles[0..1])
  end
end
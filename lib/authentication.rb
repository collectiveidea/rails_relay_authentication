module Authentication
  SECRET = ENV['SECRET_KEY_BASE'] || "server_secret"

  def create_token(args = {})
    Rails.logger.debug("create token with user id #{args[:id]}")
    args[:id] && args[:role] && JWT.encode({ userId: args[:id], password: args[:password] }, SECRET, 'HS256')
  end

  def decode_token(token)
    JWT.decode(token, SECRET, true, { :algorithm => 'HS256' }).first
  end

  def is_logged_in?(role)
    # This needs access to a global in JS. Not sure how to handle this here
    $current_user.try(:role).in?(User.roles)
  end

  def can_publish?(role)
    role.in?(User.roles[0..1])
  end
end
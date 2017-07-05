class AuthenticationTokenStrategy < ::Warden::Strategies::Base
  def valid?
    Rails.logger.debug "### AuthenticationTokenStrategy.cookies #{cookies}"
    user_uuid # && authentication_token
  end

  def authenticate!
    user = User.find_by(uuid: user_uuid)
    # pull auth token here, decrypt using server_secret, and constant time (secure) compare
    user.nil? ? fail!('strategies.authentication_token.failed') : success!(user)
  end

  private

  def user_uuid
    cookies['default.uuid']
  end

  def authentication_token
    cookies['default.authentication_token']
  end
end
class AuthenticationTokenStrategy < ::Warden::Strategies::Base
  def valid?
    user_uuid # && authentication_token
  end

  def authenticate!
    user = User.find_by(uuid: user_uuid)
    # pull auth token here, decrypt using server_secret, and constant time (secure) compare
    user.nil? ? fail!('strategies.authentication_token.failed') : success!(user)
  end

  private

  def user_uuid
    cookies['user.uuid']
  end

  def authentication_token
    cookies['user.authentication_token']
  end
end
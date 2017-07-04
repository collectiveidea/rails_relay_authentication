class AuthenticationTokenStrategy < ::Warden::Strategies::Base
  def valid?
    !!authentication_token
  end

  def authenticate!
    user = User.find_by(authentication_token: authentication_token)
    user.nil? ? fail!('strategies.authentication_token.failed') : success!(user)
  end

  private

  def authentication_token
    cookies[:authentication_token]
  end
end
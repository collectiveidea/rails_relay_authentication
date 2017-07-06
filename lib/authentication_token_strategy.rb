class AuthenticationTokenStrategy < ::Warden::Strategies::Base
  def valid?
    Rails.logger.debug "## Cookies: #{cookies.signed['default.uuid']} #{cookies.signed['default.authentication_token']}"
    user_uuid && authentication_token
  end

  def authenticate!
    if user && ActiveSupport::SecurityUtils.secure_compare(user.authentication_token, authentication_token)
      success!(user)
    else
      cookies.signed['default.uuid'] = nil
      cookies.signed['default.expires_at'] = nil
      cookies.signed['default.authentication_token'] = nil
      fail!
    end
  end

  def user
    @user ||= User.find_by(uuid: user_uuid)
  end

  def user_uuid
    cookies.signed['default.uuid']
  end

  def authentication_token
    cookies.signed['default.authentication_token']
  end
end

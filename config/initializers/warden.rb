module Warden::Mixins::Common
  def request
    @request ||= ActionDispatch::Request.new(env)
  end

  def reset_session!
    request.reset_session
  end

  def cookies
    request.cookie_jar
  end
end

require 'authentication_token_strategy'

Warden::Strategies.add(:authentication_token, AuthenticationTokenStrategy)

Rails.application.config.middleware.insert_after Rack::ETag, Warden::Manager do |manager|
  manager.default_strategies :authentication_token
  manager.failure_app = FailureApp

  # Session is for short-term user storage
  manager.serialize_into_session do |user|
    user.attributes.slice("uuid", "role")
  end

  manager.serialize_from_session do |attributes|
    Viewer.new(attributes.symbolize_keys)
  end
end

# Use warden hook to setup current_user uid in Cookie
Warden::Manager.after_set_user do |user, auth, opts|
  auth.cookies.signed["default.uuid"] = user.uuid
  auth.cookies.signed["default.authentication_token"] = user.authentication_token
  auth.cookies.signed["default.expires_at"] = 1.week.from_now
end

 # Cleanup once logged out
 Warden::Manager.before_logout do |user, auth, opts|
  auth.cookies.signed["default.uuid"] = nil
  auth.cookies.signed["default.authentication_token"] = nil
  auth.cookies.signed["default.expires_at"] = nil
  user.regenerate_authentication_token
 end

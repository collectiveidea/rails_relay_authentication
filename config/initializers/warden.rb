require 'authentication_token_strategy'

Warden::Strategies.add(:authentication_token, AuthenticationTokenStrategy)

Rails.application.config.middleware.insert_before Rack::Head, Warden::Manager do |manager|
  manager.default_strategies :authentication_token
  manager.failure_app = GraphqlController
end

class Warden::SessionSerializer
  def serialize(record)
    [record.class, record.uuid]
  end

  def deserialize(keys)
    klass, uuid = keys
    klass.find_by(uuid: id)
  end
end

# Use warden hook to setup current_user uid in Cookie
Warden::Manager.after_set_user do |user, auth, opts|
  scope = opts[:scope]
  auth.warden_cookies["#{scope}.uuid"] = user.uuid
  auth.warden_cookies["#{scope}.expires_at"] = 30.minutes.from_now
end

# Cleanup once logged out
Warden::Manager.before_logout do |user, auth, opts|
  scope = opts[:scope]
  auth.warden_cookies["#{scope}.uuid"] = nil
  auth.warden_cookies["#{scope}.expires_at"] = nil
end

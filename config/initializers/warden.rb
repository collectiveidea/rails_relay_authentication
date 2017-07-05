require 'authentication_token_strategy'

Warden::Strategies.add(:authentication_token, AuthenticationTokenStrategy)

Rails.application.config.middleware.insert_after Rack::ETag, Warden::Manager do |manager|
  manager.default_strategies :authentication_token
  manager.failure_app = GraphqlController
end

Warden::Manager.serialize_into_session do |record|
  [record.class.name, record.uuid]
end

Warden::Manager.serialize_from_session do |keys|
  class_name, uuid = keys
  klass = class_name.constantize
  klass.find_by(uuid: uuid)
end

# Use warden hook to setup current_user uid in Cookie
Warden::Manager.after_set_user do |user, auth, opts|
  #scope = opts[:scope]
  Rails.logger.debug "### Logged in warden hook, auth responds to cookies: #{auth.respond_to?(:cookies)}"

  #auth.raw_session["#{scope}.uuid"] = user.uuid
  #auth.raw_session["#{scope}.expires_at"] = 30.minutes.from_now
end

# Cleanup once logged out
Warden::Manager.before_logout do |user, auth, opts|
  scope = opts[:scope]
  #auth.cookies["#{scope}.uuid"] = nil
  #auth.cookies["#{scope}.expires_at"] = nil
end

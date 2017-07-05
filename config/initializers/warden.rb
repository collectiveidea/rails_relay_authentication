require 'authentication_token_strategy'

Warden::Strategies.add(:authentication_token, AuthenticationTokenStrategy)

Rails.application.config.middleware.insert_after Rack::ETag, Warden::Manager do |manager|
  manager.default_strategies :authentication_token
  manager.failure_app = GraphqlController
end

class Warden::SessionSerializer
  def serialize(record)
    Rails.logger.debug "### Serializer #{record}"
    result = [record.class.name, record.uuid]
    Rails.logger.debug "#   Serializing #{record} as #{result}"
    result
  end

  def deserialize(keys)
    Rails.logger.debug "### Deserializer #{keys}"
    class_name, uuid = keys
    klass = class_name.constantize
    klass.find_by(uuid: uuid)
  end
end

# Use warden hook to setup current_user uid in Cookie
Warden::Manager.after_set_user do |user, auth, opts|
  #scope = opts[:scope]
  Rails.logger.debug "### Logged in warden hook,"
  #auth.raw_session["#{scope}.uuid"] = user.uuid
  #auth.raw_session["#{scope}.expires_at"] = 30.minutes.from_now
end

# Cleanup once logged out
Warden::Manager.before_logout do |user, auth, opts|
  scope = opts[:scope]
  #auth.cookies["#{scope}.uuid"] = nil
  #auth.cookies["#{scope}.expires_at"] = nil
end

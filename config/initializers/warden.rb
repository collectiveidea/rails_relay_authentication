Rails.application.config.middleware.insert_after Rack::ETag, Warden::Manager do |manager|
  manager.failure_app = GraphqlController

  manager.serialize_into_session do |user|
    user.attributes.slice("uuid", "email", "role", "first_name", "last_name", "authentication_token")
  end

  manager.serialize_from_session do |attributes|
    Viewer.new(attributes.symbolize_keys)
  end
end

# Cleanup once logged out
Warden::Manager.before_logout do |user, auth, opts|
  user.regenerate_authentication_token
end

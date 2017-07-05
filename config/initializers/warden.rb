Rails.application.config.middleware.insert_after Rack::ETag, Warden::Manager do |manager|
  manager.failure_app = GraphqlController

  manager.serialize_into_session do |record|
    [record.class.name, record.authentication_token]
  end

  manager.serialize_from_session do |keys|
    class_name, authentication_token = keys
    class_name.constantize.find_by(authentication_token: authentication_token)
  end
end

# Cleanup once logged out
Warden::Manager.before_logout do |user, auth, opts|
  user.regenerate_authentication_token
end

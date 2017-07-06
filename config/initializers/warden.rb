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

Rails.application.config.middleware.insert_after Rack::ETag, Warden::Manager do |manager|
  manager.failure_app = GraphqlController

  manager.serialize_into_session do |user|
    user.attributes.slice("uuid", "role")
  end

  manager.serialize_from_session do |attributes|
    Viewer.new(attributes.symbolize_keys)
  end
end
Rails.application.config.middleware.insert_after Rack::ETag, Warden::Manager do |manager|
  manager.failure_app = GraphqlController

  manager.serialize_into_session do |viewer|
    viewer.to_h.slice(:id, :role)
  end

  manager.serialize_from_session do |attributes|
    API::Viewer.new(attributes.symbolize_keys)
  end
end
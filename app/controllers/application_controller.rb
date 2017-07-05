class ApplicationController < ActionController::API
  include AbstractController::Helpers
  include Rails.application.routes.url_helpers
  include ActionController::Cookies
end

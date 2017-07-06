class GraphqlController < ApplicationController
  include ActionController::Cookies

  before_action :authenticate!

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    context = {
      warden: warden,
      viewer: viewer
    }
    result = RailsRelayAuthenticationSchema.execute(query, variables: variables, context: context)
    render json: result
  end

  private

  def self.call(env)
    @respond ||= action(:execute)
    @respond.call(env)
  end

  def authenticate!
    return unless cookies.signed['default.uuid'] && cookies.signed['default.authentication_token']
    warden.authenticate!
    Rails.logger.debug "### Controller cookies #{cookies.signed['default.uuid']} #{cookies.signed['default.authentication_token']}"
  end

  def viewer
    warden.user
  end

  def warden
    request.env['warden']
  end

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
  when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end
end

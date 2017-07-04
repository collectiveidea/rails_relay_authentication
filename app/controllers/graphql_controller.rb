class GraphqlController < ApplicationController
  include Authentication

  TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIyIiwicm9sZSI6InB1Ymxpc2hlciIsImlhdCI6MTQ5OTEwOTkxMX0.tiQZ_TgW02IwApHrp0ZHrIzFBlEv0niInzLmNOvX0DU"

  def execute
    request.env['warden'].set_user User.all.first
    user = request.env['warden'].user
    variables = ensure_hash(params[:variables])
    query = params[:query]
    context = {
      # Query context goes here, for example:
      # current_user: current_user,
      tokenData: {
        userId: user.id,
        role: user.role
      }
    }.deep_symbolize_keys
    Rails.logger.debug "Context: #{context}"
    result = RailsRelayAuthenticationSchema.execute(query, variables: variables, context: context)
    render json: result
  end

  private

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

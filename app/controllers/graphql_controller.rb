class GraphqlController < ApplicationController
  
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    context = {
      request: request,
      tokenData: {
        userId: warden.user.try(:id),
        role: warden.user.try(:role)
      }
    }
    Rails.logger.debug "### Executing with tokenData #{context[:tokenData]}"
    result = RailsRelayAuthenticationSchema.execute(query, variables: variables, context: context)
    Rails.logger.debug "#     Schema executed"
    render json: result
    Rails.logger.debug "#     Result rendered #{result}"
  end

  private

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

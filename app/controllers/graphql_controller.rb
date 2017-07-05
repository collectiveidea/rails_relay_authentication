class GraphqlController < ApplicationController
  
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

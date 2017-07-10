class GraphqlController < ApplicationController
  
  def execute 
    query = params[:query]
    context = {
      warden: warden,
      viewer: viewer
    }
    result = RailsRelayAuthenticationSchema.execute(query, variables: variables, context: context)
    
    # We need serializers here because a CreatePost error will try to pass back the attached image in the
    # vector, which will break the json serliazer
    render json: result
  end

  private

  def variables
    variables_hash = ensure_hash(params[:variables])
    if params[:image] && variables_hash["input"]
      variables_hash["input"].merge!("image" => params[:image])
    end
    variables_hash
  end

  def viewer
    warden.user || Viewer.new
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

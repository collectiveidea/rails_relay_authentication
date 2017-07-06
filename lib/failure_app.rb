class FailureApp < ActionController::Metal
  include ActionController::Redirecting

  def self.call(env)
    @respond ||= action(:execute)
    @respond.call(env)
  end

  def respond
    redirect_to request.referrer
  end
end

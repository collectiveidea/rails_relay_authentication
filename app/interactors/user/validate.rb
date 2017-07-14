class User::Validate
  include Interactor  
  
  context_with User::Context

  def call
    true
  end
end
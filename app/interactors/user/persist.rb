class User::Persist
  include Interactor  
  
  context_with User::Context

  def call
    User.create(context.to_h)
  end
end
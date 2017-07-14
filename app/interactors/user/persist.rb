class User::Persist
  include Interactor  
  
  context_with User::Context

  def call
    context.id = Sequel::Model.db[:users].insert(context.to_h)
  end
end
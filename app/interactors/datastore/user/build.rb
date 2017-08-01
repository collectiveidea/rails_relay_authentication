module Datastore
  module User
    class Build
      include Interactor  
      
      context_with User::Context

      before do
        context.fail!("Password must be filled") if context.includes?(:password) && context.password.blank?
      end

      def call
        context.record = context.supplied_attributes.except(:password)
        context.record[:password_digest] = BCrypt::Password.create(context.password) if context.includes?(:password)
      end
    end
  end
end
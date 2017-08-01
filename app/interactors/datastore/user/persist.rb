module Datastore
  module User
    class Persist
      include Interactor  
      
      WHITELIST = %i(first_name last_name email password_digest role)

      context_with User::Context

      def call
        context.id = Datastore.users.insert(context.record)
        context.record[:uuid] = Datastore.users[id: context.id][:uuid]
      end

      def params
        context.record(*WHITELIST)
      end
    end
  end
end
module Datastore
  module User
    class Persist
      include Interactor  
      
      context_with User::Context

      def call
        context.id = Datastore.users.insert(context.params)
        context.record[:uuid] = Datastore.users[id: context.id][:uuid]
      end
    end
  end
end
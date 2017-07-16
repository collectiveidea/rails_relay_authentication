module Datastore
  module User
    class Persist
      include Interactor  
      
      context_with User::Context

      def call
        context.id = Sequel::Model.db[:users].insert(context.as_record)
        context.uuid = Sequel::Model.db[:users][id: context.id][:uuid]
      end
    end
  end
end
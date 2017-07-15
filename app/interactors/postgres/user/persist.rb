module Postgres
  module User
    class Persist
      include Interactor  
      
      context_with User::Context

      def call
        context.id = Sequel::Model.db[:users].insert(context.as_record)
      end
    end
  end
end
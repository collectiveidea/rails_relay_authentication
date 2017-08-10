module Datastore
  class Persist
    include Interactor  

    delegate :datastore, to: :context

    def call
      # A record's id is only set in postgres after create, so its presence means this is persisted
      # and it's therefor an update, not an insert.
      context.record = if context.id
        datastore.update(context.id, context.params)
      else
        datastore.insert(context.params)
      end
    end
  end
end
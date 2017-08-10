module Datastore
  class Persist
    include Interactor  

    delegate :datastore, to: :context

    def call
      # A record's id is only set in postgres after create, so its presence means this is persisted
      # and it's therefor an update, not an insert.
      if context.id
        datastore.where(id: context.id).update(context.params)
        context.record = datastore.where(id: context.id).first
      else
        context.id = datastore.insert(context.params)
        context.record = datastore[id: context.id]
      end
    end
  end
end
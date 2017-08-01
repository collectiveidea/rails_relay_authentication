module Datastore
  class Persist
    include Interactor  

    delegate :datastore, to: :context

    def call
      # A record's UUID is only set in postgres after create, so its presence means this is persisted
      # and it's therefor an update, not an insert.
      if context.uuid
        datastore.where(uuid: context.uuid).update(context.params)
      else
        context.id = datastore.insert(context.params)
        context.record[:uuid] = datastore[id: context.id][:uuid]
      end
    end
  end
end
module Datastore
  class Persist
    include Interactor  

    delegate :datastore, :datastore_action, to: :context

    def call
      context.id = datastore.send(datastore_action, context.params)
      context.record[:uuid] = datastore[id: context.id][:uuid]
    end
  end
end
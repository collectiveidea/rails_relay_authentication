module Datastore
  class Update
    include Interactor

    delegate :datastore, to: :context
    
    def call
      build_record = context.record_builder.call(context)
      context.fail! if build_record.failure?

      context.fail!(error: "User not found") unless user_record = datastore.where(id: context.id).first

      validate_record = Datastore::Validate.call(context)

      # Write to the db
      if validate_record.success?
        Datastore::Persist.call(context)
      else
        context.fail!(error: validate_record.error)
      end
    end
  end
end
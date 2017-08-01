module Datastore
  class Create
    include Interactor
    attr_accessor :error

    def call
      build_record = context.record_builder.call(context)
      if build_record.success?
        validate_record = Datastore::Validate.call(context)
        if validate_record.success?
          persist_record = Datastore::Persist.call(context)
          if persist_record.failure?
            error = persist_record.error
          end
        else
          error = validate_record.error
        end
      else
        error = build_record.error
      end
      context.fail!(error: error) if error
    end
  end
end
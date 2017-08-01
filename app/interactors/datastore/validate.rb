module Datastore
  class Validate
    include Interactor  
  
    def call
      validate_record = context.schema.call(context.record)
      context.fail!(error: validate_record.errors) if validate_record.failure?
    end
  end
end
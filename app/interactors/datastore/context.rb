module Datastore
  class Context < BaseContext
    def params
      record.slice(*whitelist)
    end

    def self.common_attributes
      super + %i(id uuid schema whitelist record)
    end
  end
end  
module Datastore
  class Context < BaseContext
    def self.common_attributes
      super + %i(id uuid schema record)
    end
  end
end  

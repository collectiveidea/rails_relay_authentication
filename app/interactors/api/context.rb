module API
  class Context < BaseContext
    def self.common_attributes
      super + %i(viewer)
    end
  end
end
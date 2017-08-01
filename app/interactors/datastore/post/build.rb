module Datastore
  module Post
    class Build
      include Interactor

      def call
        context.record = context.supplied_attributes
      end
    end
  end
end
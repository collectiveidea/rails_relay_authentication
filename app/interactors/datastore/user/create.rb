module Datastore
  module User
    class Create
      include Interactor
      attr_accessor :error

      context_with User::Context

      def call
        build_user = User::Build.call(context)
        if build_user.success?
          validate_user = User::Validate.call(context)
          if validate_user.success?
            persist_user = User::Persist.call(context)
            if persist_user.failure?
              error = persist_user.error
            end
          else
            error = validate_user.error
          end
        else
          error = build_user.error
        end
        context.fail!(error: error) if error
      end
    end
  end
end
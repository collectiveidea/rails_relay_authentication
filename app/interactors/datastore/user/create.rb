module Datastore
  module User
    class Create
      include Interactor
      attr_accessor :error

      context_with User::Context

      CreateUserSchema = Dry::Validation.Schema do
        required(:email, Types::Email) { filled? & format?(Types::EMAIL_REGEXP) }
        required(:role, Types::Role) { filled? & included_in?(Types::USER_ROLES.values) }
        required(:password_digest, Types::Strict::String).filled
        optional(:first_name) { filled? > str? }
        optional(:last_name) { filled? > str? }
      end

      before do
        context.schema = CreateUserSchema
        context.whitelist = %i(first_name last_name email password_digest role)
      end

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
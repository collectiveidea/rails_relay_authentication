module Datastore
  module User
    class Update
      include Interactor
      
      WHITELIST = %i(first_name last_name email password_digest role)

      context_with User::Context

      UpdateUserSchema = Dry::Validation.Schema do
        optional(:email, Types::Email) { filled? & format?(Types::EMAIL_REGEXP) }
        optional(:role, Types::Role) { filled? & included_in?(Types::USER_ROLES.values) }
        optional(:password_digest, Types::Strict::String)
        optional(:first_name) { filled? > str? }
        optional(:last_name) { filled? > str? }
      end

      before do
        context.schema = UpdateUserSchema
      end

      before do
        build_user = User::Build.call(context)
        context.fail! if build_user.failure?
      end

      def call
        find_by_param = context.uuid ? { uuid: context.uuid } : { id: context.id }
        context.fail!(error: "User not found") unless user_record = Datastore.find_by(:users, find_by_param)

        validate_user = User::Validate.call(context)

        # Write to the db
        if validate_user.success?
          Datastore.update(:users, user_record[:id], params)
        else
          context.fail!(error: validate_user.error)
        end
      end

      def params
        context.record.slice(*WHITELIST)
      end
    end
  end
end
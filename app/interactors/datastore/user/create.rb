module Datastore
  module User
    class Create < Datastore::Create
      context_with User::Context

      CreateUserSchema = Dry::Validation.Schema do
        required(:email, Types::Email) { filled? & format?(Types::EMAIL_REGEXP) }
        required(:role, Types::Role) { filled? & included_in?(Types::USER_ROLES.values) }
        required(:password_digest, Types::Strict::String).filled
        optional(:first_name) { filled? > str? }
        optional(:last_name) { filled? > str? }
      end

      before do
        context.datastore = Datastore.users
        context.schema = CreateUserSchema
        context.whitelist = %i(first_name last_name email password_digest role)
        context.record_builder = User::Build
      end
    end
  end
end
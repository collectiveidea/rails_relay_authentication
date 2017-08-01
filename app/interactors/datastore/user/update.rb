module Datastore
  module User
    class Update < Datastore::Update
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
        context.whitelist = %i(first_name last_name email password_digest role)
        context.datastore = Datastore.users
        context.record_builder = User::Build
      end
    end
  end
end
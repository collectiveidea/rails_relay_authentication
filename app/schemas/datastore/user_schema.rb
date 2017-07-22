module Datastore
  UserSchema = Dry::Validation.Schema do
    required(:email, Types::Email) { filled? & format?(Types::EMAIL_REGEXP) }
    required(:role, Types::Role) { filled? & included_in?(API::User::ROLES.values) }
    required(:password_digest, Types::Strict::String).filled
    
    optional(:first_name) { filled? > str? }
    optional(:last_name) { filled? > str? }
    optional(:password) { filled? > str? }
    optional(:authentication_token) { filled? > str? }
  end
end
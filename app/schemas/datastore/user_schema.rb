module Datastore
  UserSchema = Dry::Validation.Schema do
    required(:email, Types::Email) { filled? & format?(Types::EMAIL_REGEXP) }
    required(:role, Types::Role) { filled? & included_in?(Types::USER_ROLES.values) }
    required(:password_digest, Types::Strict::String).filled
    
    optional(:password) { filled? > min_size?(6) }
    optional(:first_name) { filled? > str? }
    optional(:last_name) { filled? > str? }
    optional(:password) { filled? > str? }
    optional(:authentication_token) { filled? > str? }
  end
end
module UserPostgres
  extend ActiveSupport::Concern

  def to_postgres
    {
      uuid: id,
      first_name: first_name,
      last_name: last_name,
      email: email,
      role: User::ROLES[role],
      authentication_token: authentication_token,
      password: password,
      password_digest: password_digest
    }
  end

  module ClassMethods
    def from_postgres(attrs)
      new(
        id: attrs[:uuid],
        first_name: attrs[:first_name],
        last_name: attrs[:last_name],
        email: attrs[:email],
        role: User::ROLES.keys[attrs[:role]],
        authentication_token: attrs[:authentication_token],
        created_at: attrs[:created_at],
        updated_at: attrs[:updated_at]
      )
    end
  end
end
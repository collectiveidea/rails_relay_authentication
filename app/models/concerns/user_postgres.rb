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

  def regenerate_authentication_token!
    # Postgres::User::NewAuthToken.call(id: id).authentication_token
    # self[:authentication_token] = SecureRandom.base58(24)
  end

  module ClassMethods
    def attrs_for_postgres(attrs)
      new(attrs).to_postgres
    end

    def find(uuid)
      find_by(uuid: Types::UUID[uuid]) if uuid.present?
    end

    def create(args)
      user_attrs = attrs_for_postgres(args)
      from_postgres Postgres::User.create(user_attrs)
    end

    def where(params)
      Postgres::User.where(params).map do |user_record|
        from_postgres user_record
      end
    end

    def find_by(params)
      from_postgres Postgres::User.find_by(params)
    end

    def from_postgres(attrs={})
      new(
        id: attrs[:uuid],
        first_name: attrs[:first_name],
        last_name: attrs[:last_name],
        email: attrs[:email],
        role: User::ROLES.keys[attrs[:role]],
        authentication_token: attrs[:authentication_token]
      )
    end
  end
end
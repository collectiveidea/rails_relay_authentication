module UserDatastore
  extend ActiveSupport::Concern

  def to_datastore
    {
      uuid: id,
      first_name: first_name,
      last_name: last_name,
      email: email,
      role: User::ROLES[role.to_s],
      authentication_token: authentication_token,
      password: password,
      password_digest: password_digest
    }
  end

  def regenerate_authentication_token!
    # Datastore::User::NewAuthToken.call(id: id).authentication_token
    # self[:authentication_token] = SecureRandom.base58(24)
  end

  module ClassMethods
    def attrs_for_datastore(attrs)
      new(attrs).to_datastore
    end

    def find(uuid)
      find_by(uuid: Types::UUID[uuid]) if uuid.present?
    end

    def create(args)
      user_attrs = attrs_for_datastore(args)
      from_datastore Datastore::User.create(user_attrs)
    end

    def where(params)
      Datastore::User.where(params).map do |user_record|
        from_datastore user_record
      end
    end

    def find_by(params)
      from_datastore Datastore::User.find_by(params)
    end

    def delete_all
      Datastore::User.delete_all
    end

    def from_datastore(attrs={})
      new(
        id: attrs[:uuid] || attrs["uuid"],
        first_name: attrs[:first_name] || attrs["first_name"],
        last_name: attrs[:last_name] || attrs["last_name"],
        email: attrs[:email] || attrs["email"],
        role: User::ROLES.keys[attrs[:role] || attrs["role"]],
        authentication_token: attrs[:authentication_token] || attrs["authentication_token"],
        password_digest: attrs[:password_digest] || attrs["password_digest"],
        password: nil
      )
    end
  end
end
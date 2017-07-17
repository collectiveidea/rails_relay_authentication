module UserDatastore
  extend ActiveSupport::Concern

  def regenerate_authentication_token!
    # Datastore::User::NewAuthToken.call(id: id).authentication_token
    # self[:authentication_token] = SecureRandom.base58(24)
  end

  module ClassMethods
    def find(uuid)
      find_by(uuid: Types::UUID[uuid]) if uuid.present?
    end

    def where(params)
      Datastore::User.where(params).map do |user_record|
        from_datastore user_record
      end
    end

    def find_by(params)
      if user = Datastore::User.find_by(params)
        from_datastore(user)
      end
    end

    def delete_all
      Datastore::User.delete_all
    end

    def all
      Datastore::User.all.map do |user_record|
        from_datastore user_record
      end
    end

    def from_datastore(attrs={})
      attrs = attrs.symbolize_keys
      new(
        id: attrs[:uuid],
        first_name: attrs[:first_name],
        last_name: attrs[:last_name],
        email: attrs[:email],
        role: attrs[:role] ? User::ROLES.keys[attrs[:role]] : nil,
        authentication_token: attrs[:authentication_token],
        password_digest: attrs[:password_digest],
        password: nil,
        errors: attrs[:errors] || {}
      )
    end
  end
end
module UserAPI
  extend ActiveSupport::Concern

  def to_api
    {
      id: id,
      firstName: first_name,
      lastName: last_name,
      email: email,
      role: role,
      authentication_token: authentication_token,
      password_digest: password_digest
    }
  end

  module ClassMethods
    def find_for_api(id)
      user_attrs = find(id).to_api
      API::User.new(user_attrs)
    end

    def from_api(attrs)
      new(
        id: attrs[:id] || attrs["id"],
        first_name: attrs[:firstName] || attrs["firstName"],
        last_name: attrs[:lastName] || attrs["lastName"],
        email: attrs[:email] || attrs["email"],
        password: attrs[:password] || attrs["password"],
        password_digest: nil,
        role: attrs[:role] || attrs["role"],
        authentication_token: attrs[:authentication_token] || attrs["authentication_token"]
      )
    end
  end
end
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
    }
  end

  module ClassMethods
    def find_for_api(id)
      user_attrs = find(id).to_api
      API::User.new(user_attrs)
    end

    def from_api(attrs)
      new(
        id: attrs[:id],
        first_name: attrs[:firstName],
        last_name: attrs[:lastName],
        email: attrs[:email],
        password: attrs[:password],
        role: attrs[:role],
        authentication_token: attrs[:authentication_token]
      )
    end
  end
end
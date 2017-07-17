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
    def from_api(attrs)
      attrs = attrs.symbolize_keys
      new(
        id: attrs[:id],
        first_name: attrs[:firstName],
        last_name: attrs[:lastName],
        email: attrs[:email],
        password: attrs[:password],
        password_digest: nil,
        role: attrs[:role],
        authentication_token: attrs[:authentication_token]
      )
    end
  end
end
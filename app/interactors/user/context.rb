class User
  class Context < BaseContext
    def self.accessors
      super + %i(email first_name last_name role password password_digest authentication_token)
    end

    attr_accessor *accessors
  end
end
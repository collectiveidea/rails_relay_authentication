class User
  class Context < BaseContext
    def self.accessors
      super + %i(email first_name last_name role password password_digest authentication_token)
    end

    attr_accessor *accessors

    def as_record
      super.except("password").merge("password_digest" => password_digest)
    end

    private

    def key_transforms
      {
        "firstName" => "first_name",
        "lastName" => "last_name"
      }
    end
  end
end
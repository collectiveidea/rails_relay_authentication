module API
  class Register
    include Interactor

    class Context < BaseContext
      def self.accessors
        %i(id email password firstName lastName role user error)
      end
      attr_accessor *accessors
    end
    context_with Context

    def call
      create_user = Datastore::User::Create.call(user_attributes)

      if create_user.success?
        context.user = API::User.from_datastore(create_user.full_attributes)
      else
        context.fail!(error: create_user.error)
      end
    end

    def user_attributes
      API::User.to_datastore(
        email:     context.email,
        password:  context.password,
        firstName: context.firstName,
        lastName:  context.lastName,
        role:      context.role || "reader",
      ).merge(password_digest: nil)
    end
  end
end
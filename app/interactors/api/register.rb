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
      # TODO: Needs real validations and a better sad path
      context.fail!(error: "Email missing") unless context.email.present?
      context.fail!(error: "Password missing") unless context.password.present?

      context.user = API::User.create(
        email: context.email,
        password: context.password,
        firstName: context.firstName,
        lastName: context.lastName,
        role: context.role || "reader",
      )
    end
  end
end
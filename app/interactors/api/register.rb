module API
  class Register
    include Interactor
    include API::WithDatastore

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
        context.user = user_from_datastore(create_user.to_h)
      else
        context.fail!(error: create_user.error)
      end
    end

    def user_attributes
      user_attributes_for_datastore(
        id: context.id,
        email: context.email,
        password: context.password,
        firstName: context.firstName,
        lastName: context.lastName,
        role: context.role || "reader",
      )
    end
  end
end
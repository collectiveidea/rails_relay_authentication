module API
  class Register
    include Interactor

    class Context < API::Context
      inputs :id, :email, :password, :firstName, :lastName, :role
      outputs :user
    end
    context_with Context

    before do
      context.fail!(error: "Forbidden") if context.viewer.try(:is_logged_in)
    end

    def call
      create_user = Datastore::User::Create.call(user_attributes)

      if create_user.success?
        context.user = API::User.from_datastore(create_user.record)
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
      )
    end
  end
end
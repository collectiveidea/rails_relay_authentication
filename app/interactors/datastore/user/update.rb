module Datastore
  module User
    class Update
      include Interactor
      attr_accessor :error

      context_with User::Context

      before do
        context.password_digest = BCrypt::Password.create(context.password) if context.password.present?
      end

      def call
        find_by_param = context.uuid ? { uuid: context.uuid } : { id: context.id }
        context.fail!(error: "User not found") unless user_record = Datastore.find_by(:users, find_by_param)

        # Do validation
        context.update(
          user_record.merge(context.modifiable_attributes)      
        )
        validate_user = User::Validate.call(context)

        # Write to the db
        if validate_user.success?
          Datastore.update(:users, user_record[:id], context.modifiable_attributes.except(:password))
        else
          error = validate_user.error
        end
        context.fail!(error: error) if error
      end
    end
  end
end
module Datastore
  module User
    class Update
      include Interactor
      
      WHITELIST = %i(first_name last_name email password_digest role)

      context_with User::Context

      before do
        build_user = User::Build.call(context)
        context.fail! if build_user.failure?
      end

      def call
        find_by_param = context.uuid ? { uuid: context.uuid } : { id: context.id }
        context.fail!(error: "User not found") unless user_record = Datastore.find_by(:users, find_by_param)

        # This whole approach is wrong. Need to fix validation for updates first, then just
        # don't do this. It's only needed because we're requiring all the fields in the 
        # validation
        context.record = user_record.merge(context.record)

        validate_user = User::Validate.call(context)

        # Write to the db
        if validate_user.success?
          Datastore.update(:users, user_record[:id], params)
        else
          context.fail!(error: validate_user.error)
        end
      end

      def params
        context.record.slice(*WHITELIST)
      end
    end
  end
end
module Postgres
  module User
    class Build
      include Interactor  
      
      context_with User::Context

      def call
        role_name = Types::Role["#{context.role}"]
        context.role = ROLES[role_name]

        if context.password.present?
          password_string = Types::Password[context.password]
          context.password_digest = BCrypt::Password.create(password_string)
        end    
      end
    end
  end
end
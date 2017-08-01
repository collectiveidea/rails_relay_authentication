module Datastore
  module User
    class Context < Datastore::Context
      inputs :email, :first_name, :last_name, :role, :password
    end
  end
end
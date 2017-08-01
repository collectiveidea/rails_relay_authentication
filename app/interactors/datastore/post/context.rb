module Datastore
  module Post
    class Context < Datastore::Context
      inputs :title, :description, :image, :user_uuid
    end
  end
end
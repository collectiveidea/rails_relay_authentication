module Datastore
  module Post
    class Context < Datastore::Context
      inputs :title, :description, :image, :user_id
    end
  end
end
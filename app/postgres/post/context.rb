class Post
  class Context < BaseContext
    def self.accessors
      super + %i(title description image user_id)
    end

    attr_accessor *accessors

    def key_transforms
      {
        "creatorId" => "user_id"
      }
    end

  end
end
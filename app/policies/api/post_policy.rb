module API
  class PostPolicy
    attr_reader :viewer, :post

    def initialize(viewer, post)
      @viewer = viewer
      @post = post
    end

    def show?
      true
    end

    def update?
      viewer.admin? || post.creatorId == viewer.id
    end
  
    alias_method :delete?, :update?

    def self.create?(viewer)
      !!viewer.try(:can_publish)
    end
  end
end
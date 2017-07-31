module API
  class PostPolicy
    attr_reader :viewer, :post

    def initialize(viewer, post)
      @viewer = viewer
      @post = post
    end

    def create?
      viewer.can_publish
    end

    def show?
      true
    end

    def update?
      viewer.admin? || post.creatorId == viewer.id
    end
  
    alias_method :delete?, :update?
  end
end
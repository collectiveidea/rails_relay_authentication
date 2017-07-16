module API
  class CreatePost
    include Interactor

    class Context < BaseContext
      def self.accessors
        %i(id title description image creatorId post)
      end
      attr_accessor *accessors
    end
    context_with Context

    def call
      # TODO: Needs a sad path
      context.post = Post.create(
        creatorId: context.creatorId,
        title: context.title,
        description: context.description,
        image: context.image
      )
    end
  end
end
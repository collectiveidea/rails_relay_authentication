module API
  class CreatePost
    include Interactor

    class Context < BaseContext
      def self.accessors
        %i(id title description image creatorId post error)
      end
      attr_accessor *accessors
    end
    context_with Context

    delegate :image, to: :context

    def call
      context.fail!(error: "Image missing") unless context.image
      context.fail!(error: "Title missing") unless context.title.present?
      context.fail!(error: "Description missing") unless context.description.present?

      # TODO: Needs more sad path
      context.post = Post.create(
        creatorId: context.creatorId,
        title: context.title,
        description: context.description,
        image: write_image
      )
    end

    def write_image
      FileUtils.mv image.tempfile, Rails.root.join("static", "images", "upload", image.original_filename)
      "/images/upload/#{image.original_filename}"
    end
  end
end
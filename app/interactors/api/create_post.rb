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
      context.fail!(error: "image must be filled") unless image.present?
      create_post = Datastore::Post::Create.call(post_attributes)
      
      if create_post.success?
        context.post = API::Post.from_datastore(create_post.full_attributes)
      else
        context.fail!(error: create_post.error)
      end
    end

    def post_attributes
      API::Post.to_datastore(
        creatorId:   context.creatorId,
        title:       context.title,
        description: context.description,
        image:       write_image
      )
    end

    def write_image
      FileUtils.mv image.tempfile, Rails.root.join("static", "images", "upload", image.original_filename)
      "/images/upload/#{image.original_filename}"
    end
  end
end
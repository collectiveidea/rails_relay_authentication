module API
  class UpdatePost
    include Interactor

    context_with(
      Class.new(API::Context) do
        inputs :id, :title, :description, :image, :creatorId, :post
      end      
    )

    delegate :image, to: :context

    before do
      context.fail!(error: "Resource not found") unless context.post = API::Post.find(context.id)
      context.fail!(error: "Forbidden") unless context.post.authorize(context.viewer, :update)
      context.fail!(error: "Nothing to do") unless context.supplied_attributes.slice(:title, :description, :image).any?
    end

    def call
      context.image = write_image if context.image

      update_post = Datastore::Post::Update.call(post_attributes)
      
      if update_post.success?
        context.post = API::Post.from_datastore(update_post.record)
      else
        context.fail!(error: update_post.error)
      end
    end

    def post_attributes
      API::Post.to_datastore(context.supplied_attributes.except(:viewer))
    end

    def write_image
      @write_image ||= begin
        FileUtils.mv image.tempfile, Rails.root.join("static", "images", "upload", image.original_filename)
        "/images/upload/#{image.original_filename}"
      end
    end
  end
end
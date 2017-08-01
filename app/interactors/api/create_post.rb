module API
  class CreatePost
    include Interactor

    context_with(
      Class.new(API::Context) do
        inputs :id, :title, :description, :image, :creatorId, :post
      end      
    )

    delegate :image, to: :context

    def call
      context.fail!(error: "Forbidden") unless API::Post.authorize(context.viewer, :create)
      context.fail!(error: "image must be filled") unless image.present?
      create_post = Datastore::Post::Create.call(post_attributes)
      
      if create_post.success?
        context.post = API::Post.from_datastore(create_post.record)
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
      @write_image ||= begin
        FileUtils.mv image.tempfile, Rails.root.join("static", "images", "upload", image.original_filename)
        "/images/upload/#{image.original_filename}"
      end
    end
  end
end
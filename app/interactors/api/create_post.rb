module API
  class CreatePost
    include Interactor

    context_with(
      Class.new(API::Context) do
        inputs :id, :title, :description, :image, :creatorId, :post
      end      
    )

    delegate :image, to: :context

    before do
      context.fail!(error: "Forbidden") unless API::Post.authorize(context.viewer, :create)      
    end

    def call
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
      s3_client.put_object({
        acl: "public-read",
        body: image.tempfile, 
        bucket: Figaro.env.assets_bucket, 
        key: image.original_filename
      })
      "https://s3.amazonaws.com/#{Figaro.env.assets_bucket}/#{image.original_filename}"
    end

    def s3_client
      @s3_client ||= Aws::S3::Client.new(region: 'us-east-1')
    end
  end
end
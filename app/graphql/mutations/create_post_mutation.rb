Mutations::CreatePostMutation = GraphQL::Relay::Mutation.define do
  name  'CreatePost'

  input_field :title, !types.String
  input_field :description, !types.String
  input_field :image, Types::ImageType

  return_field :user, Types::UserType
  return_field :postEdge, Types::PostType.edge_type
  
  resolve ->(object, inputs, ctx) {
    user = ctx[:viewer].user
    image = inputs[:image]

    FileUtils.mv image.tempfile, Rails.root.join("static", "images", "upload", image.original_filename)

    new_post = user.posts.build(
      title: inputs[:title],
      description: inputs[:description],
      image: "/images/upload/#{image.original_filename}"   
    )

    if new_post.save
      # Use this helper to create the response that a
      # client-side RANGE_ADD mutation would expect.
      range_add = GraphQL::Relay::RangeAdd.new(
        parent: user,
        collection: Post.all,
        item: new_post.reload, # reload picks up the newly generated UUID
        context: ctx,
      )

      {
        user: user,
        postEdge: range_add.edge,
      }
    else
      GraphQL::ExecutionError.new("#{new_post.errors.messages}")
    end
  }
end

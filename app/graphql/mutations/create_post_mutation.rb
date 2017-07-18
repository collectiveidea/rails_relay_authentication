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

    create_post = API::CreatePost.call(
      creatorId: user.id,
      title: inputs[:title],
      description: inputs[:description],
      image: inputs[:image]   
    )
    
    if create_post.success?
      # Use this helper to create the response that a
      # client-side RANGE_ADD mutation would expect.
      range_add = GraphQL::Relay::RangeAdd.new(
        parent: user,
        collection: user.posts,
        item: create_post.post,
        context: ctx,
      )

      {
        user: user,
        postEdge: range_add.edge,
      }
    else
      GraphQL::ExecutionError.new(create_post.error)
    end
  }
end

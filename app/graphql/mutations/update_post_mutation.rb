Mutations::UpdatePostMutation = GraphQL::Relay::Mutation.define do
  name  'UpdatePost'

  input_field :id, !types.ID 
  input_field :title, types.String
  input_field :description, types.String
  input_field :image, Types::ImageType

  return_field :post, Types::PostType
  
  resolve ->(object, inputs, ctx) {
    user = ctx[:viewer].user

    attrs = {
      viewer: ctx[:viewer],
      creatorId: user.id,
      id: inputs[:id]
    }

    attrs[:title] = inputs[:title] if inputs.keys.include? "title"
    attrs[:description] = inputs[:description] if inputs.keys.include? "description"
    attrs[:image] = inputs[:image] if inputs.keys.include? "image"

    update_post = API::UpdatePost.call(attrs)

    if update_post.success?
      { post: update_post.post }
    else
      GraphQL::ExecutionError.new(update_post.error)
    end
  }
end

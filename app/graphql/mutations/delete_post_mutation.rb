Mutations::DeletePostMutation = GraphQL::Relay::Mutation.define do
  name  'DeletePost'

  input_field :id, !types.ID
  return_field :user, Types::UserType

  resolve ->(object, inputs, ctx) {
    delete_post = API::DeletePost.call(id: inputs[:id])

    if delete_post.success?
      { user: ctx[:viewer].user }
    else
      GraphQL::ExecutionError.new(delete_post.error)
    end
    
  }
end

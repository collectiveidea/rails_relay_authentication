Mutations::ForgotPasswordMutation = GraphQL::Relay::Mutation.define do
  name  'ForgotPassword'

  input_field :email, !types.String

  return_field :user, Types::UserType

  resolve ->(object, inputs, ctx) {
    Rails.logger.debug "#{inputs[:email]} forgot their password!"
    puts "#{inputs[:email]} forgot their password!"

    { user: nil } 
  }
end

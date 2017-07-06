Types::ImageType = GraphQL::ScalarType.define do
  name "Image"
  description "Action::Dispatch Uploaded File"
  coerce_input ->(file, ctx) {
    binding.pry
    file
  }
end

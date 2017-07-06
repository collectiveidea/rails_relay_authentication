Types::ImageType = GraphQL::ScalarType.define do
  name "Image"
  description "Action::Dispatch Uploaded File"
  coerce_input ->(file, ctx) {
    file
  }
end

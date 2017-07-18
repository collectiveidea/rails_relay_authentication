module Datastore
  PostSchema = Dry::Validation.Schema do
    required(:title, Types::Strict::String).filled
    required(:description, Types::Strict::String).filled
    required(:image, Types::Strict::String).filled
  end
end
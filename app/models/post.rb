class Post < Sequel::Model
  include RecordHelpers

  many_to_one :user
end
class Post < Sequel::Model
  include RecordHelpers

  many_to_one :user

  alias_method :creatorId, :user_id
  alias_method :creatorId=, :user_id=
end
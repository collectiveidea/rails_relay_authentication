Post.delete_all
User.delete_all

users = JSON.parse(
  File.open(Rails.root.join('spec', 'fixtures', 'users.json'), "r") { |f| f.read }
)

users.map! do |attrs|
  begin
    API::Register.call(attrs)
  #rescue Exception => e
    #binding.pry
  end
end

user_ids = Datastore.users.select(:uuid).to_a

JSON.parse(
  File.open(Rails.root.join('spec', 'fixtures', 'posts.json'), "r") { |f| f.read }
).map do |attrs|
  index = attrs["creatorId"].to_i - 1
  transformed_attrs = attrs.merge("user_id" => user_ids[index][:uuid])
  transformed_attrs.except!("creatorId")
  Datastore::Post::Create.call(transformed_attrs)
end

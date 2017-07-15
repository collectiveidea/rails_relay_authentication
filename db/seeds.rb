Post.delete_all
User.delete_all

users = JSON.parse(
  File.open(Rails.root.join('spec', 'fixtures', 'users.json'), "r") { |f| f.read }
)

users.map! do |attrs|
  begin
    User::Create.call(attrs)
  rescue Exception => e
    #binding.pry
  end
end

JSON.parse(
  File.open(Rails.root.join('spec', 'fixtures', 'posts.json'), "r") { |f| f.read }
).map do |attrs|
  creator_id = attrs.delete("creatorId").to_i
  Post::Create.call(attrs.merge(user_id: users[creator_id - 1].id))
end

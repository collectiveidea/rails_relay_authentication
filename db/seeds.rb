User.delete_all
Post.delete_all

users = JSON.parse(
  File.open(Rails.root.join('spec', 'fixtures', 'users.json'), "r") { |f| f.read }
).map do |attrs|
    User.new(attrs)
end

users.each do |user|
  begin
    user.save!
  rescue => Exception
    binding.pry
  end
end

JSON.parse(
  File.open(Rails.root.join('spec', 'fixtures', 'posts.json'), "r") { |f| f.read }
).map do |attrs|
  creator_id = attrs.delete("creatorId").to_i
  Post.create!(attrs.merge(user_id: users[creator_id - 1].id))
end

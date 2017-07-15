Post.delete_all
User.delete_all

users = JSON.parse(
  File.open(Rails.root.join('spec', 'fixtures', 'users.json'), "r") { |f| f.read }
)

users.map! do |attrs|
  begin
    user_attrs = User.from_api(attrs)
    User.create(user_attrs)
  #rescue Exception => e
    #binding.pry
  end
end

user_ids = Sequel::Model.db[:users].select(:uuid).to_a

JSON.parse(
  File.open(Rails.root.join('spec', 'fixtures', 'posts.json'), "r") { |f| f.read }
).map do |attrs|
  index = attrs["creatorId"].to_i - 1
  transformed_attrs = attrs.merge("creatorId" => user_ids[index][:uuid])
  post_attrs = Post.from_api(transformed_attrs)
  Post.create(post_attrs)
end

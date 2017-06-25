class Database
  attr_reader :users, :posts

  def initialize
    @users = JSON.parse ApplicationController.render(file: Rails.root.join('spec', 'fixtures', 'users.json.erb'))
    @posts = JSON.parse File.open(Rails.root.join('spec', 'fixtures', 'posts.json'), "r") { |f| f.read }
  end
end

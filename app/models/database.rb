class Database
  include Authentication

  def initialize
    @users = JSON.parse(
      ApplicationController.render(file: Rails.root.join('spec', 'fixtures', 'users.json.erb'))
    ).map do |attrs|
        User.new(attrs)
    end
    @posts = JSON.parse(
      File.open(Rails.root.join('spec', 'fixtures', 'posts.json'), "r") { |f| f.read }
    ).map do |attrs|
      Post.new(attrs)
    end
  end

  def create_post(post_attrs, user_attrs)
    if !can_publish?(user_attrs[:role])
      raise ERRORS.forbidden
    end

    @posts.push(
      Post.new(
        id:          "#{posts.length + 1}",
        creator_id:  post_attrs[:creator_id],
        title:       post_attrs[:title],
        description: post_attrs[:description],
        image:       post_attrs[:image]
      )      
    )
  end

  def get_post(id)
    @posts.detect do |post|
      post.id == id
    end
  end

  def get_posts
    @posts
  end

  def get_posts_for_creator(user_attrs)
    if !is_logged_in?(user_attrs[:role])
      return []
    end

    @posts.select do |post|
      post.creator_id = user_attrs[:id]
    end
  end

  def get_post_creator(post)
    user = get_user(post.creator_id)
    {
      first_name: user.first_name,
      last_name: user.last_name
    }
  end

  def get_user(id)
    @users.detect do |user|
      user.id == id
    end
  end

  def get_user_with_credentials(email, password)
    user = @users.detect do |user_data|
      user_data.email == email && user_data.password == password
    end

    if !user
      raise ERRORS.wrong_email_or_password
    end

    user
  end

  def create_user(user_attrs)
    existing_user = @users.detect { |user| user.email == user_attrs[:email] }
    
    if existing_user
      raise ERRORS.email_already_taken
    end

    new_user = User.new(
      id: "#{users.length + 1}",
      email: user_attrs[:email],
      password: user_attrs[:password],
      first_name: user_attrs[:first_name],
      last_name: user_attrs[:last_name],
      role: user_attrs[:role] || User::ROLES.reader                                    
    )

    @users.push(new_user)
    { user: new_user }
  end

  def self.db
    @db ||= new
  end
end

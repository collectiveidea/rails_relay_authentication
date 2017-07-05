class Database
  def create_post(post_attrs, user)
    GraphQL::ExecutionError.new("Forbidden") unless can_publish?(user.role)

    Post.create!(
      creator_id:  post_attrs[:creator_id],
      title:       post_attrs[:title],
      description: post_attrs[:description],
      image:       post_attrs[:image]
    )      
  end

  def get_post(id)
    return unless id.present?

    Post.find(id)
  end

  def get_posts
    Post.all
  end

  def get_posts_for_creator(user)
    user.try(:posts) || []
  end

  def get_post_creator(post)
    {
      first_name: post.user.first_name,
      last_name: post.user.last_name
    }
  end

  def get_user(id)
    return unless id.present?

    User.find_by(id: id)
  end

  def create_user(user_attrs)
    existing_user = User.find_by(email: user_attrs[:email])
    
    return GraphQL::ExecutionError.new("Email already taken") if existing_user

    new_user = User.create!(
      email: user_attrs[:email],
      password: user_attrs[:password],
      first_name: user_attrs[:firstName],
      last_name: user_attrs[:lastName],
      role: user_attrs[:role] || :reader                                    
    )

    { user: new_user }
  end

  def self.db
    @db ||= new
  end
end

class Database
  include Authentication

  def create_post(post_attrs, user_attrs)
    if !can_publish?(user_attrs[:role])
      raise ERRORS.forbidden
    end

    Post.create!(
      creator_id:  post_attrs[:creator_id],
      title:       post_attrs[:title],
      description: post_attrs[:description],
      image:       post_attrs[:image]
    )      

  end

  def get_post(id)
    Post.find(id)
  end

  def get_posts
    Post.all
  end

  def get_posts_for_creator(user_attrs)
    if !is_logged_in?(user_attrs[:role])
      return []
    end

    User.find(user_attrs[:id]).posts
  end

  def get_post_creator(post)
    user = get_user(post.creator_id)
    {
      first_name: user.first_name,
      last_name: user.last_name
    }
  end

  def get_user(id)
    return unless id.present?

    if id.try(:length) == 1
      User.all.to_a[id.to_i]
    else
      User.find_by(id: id.to_i)
    end
  end

  def get_user_with_credentials(email, password)
    # TODO: Fix the login!
    User.find_by(email: email)

    if !user
      raise ERRORS.wrong_email_or_password
    end

    user
  end

  def create_user(user_attrs)
    existing_user = User.find_by(email: user_attrs[:email])
    
    if existing_user
      raise ERRORS.email_already_taken
    end

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

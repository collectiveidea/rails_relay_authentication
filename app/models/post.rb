class Post
  def initialize(args)
    @id = args[:id]
    @creator_id = args[:creator_id]
    @title = args[:title]
    @image = args[:image]
    @description = args[:description]
  end
end
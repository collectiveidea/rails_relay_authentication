class User
  def initialize(args)
    @id = args[:id]
    @email = args[:email]
    @password = args[:password]
    @role = args[:role]
    @first_name = args[:first_name]
    @last_name = args[:last_name]
  end
end
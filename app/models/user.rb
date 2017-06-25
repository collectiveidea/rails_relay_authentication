class User
  # TODO: Replace these with ActiveRecord::Enum
  ROLES = Struct.new("Roles", :reader, :publisher, :admin).new('reader', 'publisher', 'admin')

  def initialize(args)
    @id = args[:id]
    @email = args[:email]
    @password = args[:password]
    @role = args[:role]
    @first_name = args[:first_name]
    @last_name = args[:last_name]
  end
end
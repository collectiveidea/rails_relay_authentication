class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # TODO: Replace these with ActiveRecord::Enum
  ROLES = Struct.new("Roles", :reader, :publisher, :admin).new('reader', 'publisher', 'admin')
  ATTRIBUTES = %i(id email password role first_name last_name)

  attr_accessor *ATTRIBUTES

  def initialize(args)
    @args = args
    args.each do |attr, value|
      self.send("#{attr}=", value)  
    end
  end

  def firstName
    first_name
  end
  
  def firstName=(value)
    @first_name = value
  end

  def lastName
    last_name
  end
  
  def lastName=(value)
    @last_name = value
  end

  def self.roles
    [
      ROLES.admin,
      ROLES.publisher,
      ROLES.reader                  
    ]
  end
end
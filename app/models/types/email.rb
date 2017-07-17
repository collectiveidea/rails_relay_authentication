module Types
  EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  Email = Types::Strict::String.constructor do |value|
    value.downcase
  end.constrained(format: EMAIL_REGEXP)
end
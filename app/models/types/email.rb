module Types
  Email = Types::Strict::String.constructor do |value|
    value.downcase
  end.constrained(format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
end
module Types
  Password = Types::Strict::String.constrained(min_size: 6)
end
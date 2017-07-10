module Types
  Role = Types::Strict::String.enum('reader', 'publisher', 'admin')
end
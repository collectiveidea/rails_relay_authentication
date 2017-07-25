module Types
  USER_ROLES = { "reader" => 0, "publisher" => 1, "admin" => 2 }
  
  Role = Types::Strict::String.enum(*Types::USER_ROLES.keys)
end
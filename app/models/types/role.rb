module Types
  Role = Types::Strict::String.enum(*User::ROLES.keys)
end
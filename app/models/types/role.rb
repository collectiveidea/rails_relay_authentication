module Types
  Role = Types::Strict::String.enum(*API::User::ROLES.keys)
end
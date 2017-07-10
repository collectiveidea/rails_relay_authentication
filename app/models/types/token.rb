module Types
  Token = Strict::String.default { SecureRandom.base58(24) }
end
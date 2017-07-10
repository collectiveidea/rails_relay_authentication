module Types
  UUID = Strict::String.constructor do |value|
    Types.normalize_uuid(value)
  end.constrained(
    format: UUID_NORMALIZED_REGEXP    
  )
end
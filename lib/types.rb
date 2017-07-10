module Types
  include Dry::Types.module

  # based on http://www.postgresql.org/docs/9.3/static/datatype-uuid.html
  UUID_REGEXP            = /\A([0-9a-f]{4}-?){7}[0-9a-f]{4}\z/i
  UUID_NORMALIZED_REGEXP = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/

  module ClassMethods
    def normalize_uuid(uuid)
      return nil unless uuid.present? && String === uuid
      return uuid if uuid =~ Types::UUID_NORMALIZED_REGEXP

      no_dashes = uuid.gsub("-", "").downcase
      if no_dashes.size == 32
        [no_dashes[0, 8], no_dashes[8, 4], no_dashes[12, 4], no_dashes[16, 4], no_dashes[20, 12]].join("-")
      else
        nil
      end
    end
  end
  extend ClassMethods
end
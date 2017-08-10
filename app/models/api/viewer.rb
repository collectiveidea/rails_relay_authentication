module API
  class Viewer < Dry::Struct
    constructor :schema

    attribute :id, Types::Strict::Int.optional.default(nil)
    attribute :role, Types::Role.optional.default(nil)

    def can_publish
      role.in?(User.publisher_roles)
    end

    def is_logged_in
      !!(role && id)
    end

    def user
      return unless id.present?
      @user ||= API::User.find(id)
    end

    def admin?
      role == 'admin'
    end
  end
end
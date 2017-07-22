module API
  module DatastoreAdapter
    extend ActiveSupport::Concern

    def user_attributes_for_datastore(attrs)
      Hash[
        attrs.map do |k, v|
          key = k.to_sym
          if key == :id
            [:uuid, v]
          elsif key == :role
            [key, ::User::ROLES[v.to_s]]
          elsif key == :firstName
            [:first_name, v]
          elsif key == :lastName
            [:last_name, v]
          else
            [key, v]
          end
        end
      ]
    end

    def user_from_datastore(attrs={})
      attrs = attrs.symbolize_keys
      API::User.new(
        id:                   attrs[:uuid],
        firstName:            attrs[:first_name],
        lastName:             attrs[:last_name],
        email:                attrs[:email],
        role:                 attrs[:role] ? ::User::ROLES.keys[attrs[:role]] : nil,
        authentication_token: attrs[:authentication_token],
        password_digest:      attrs[:password_digest]
      )
    end

    def post_attributes_for_datastore(attrs)
      attrs.transform_keys do |k|
        key = k.to_sym
        if key == :id
          :uuid
        elsif key == :creatorId
          :user_id
        else
          key
        end
      end
    end

    def post_from_datastore(attrs={})
      attrs = attrs.symbolize_keys
      API::Post.new(
        id:          attrs[:uuid],
        title:       attrs[:title],
        description: attrs[:description],
        image:       attrs[:image],
        creatorId:   attrs[:user_id]
      )
    end
  end
end
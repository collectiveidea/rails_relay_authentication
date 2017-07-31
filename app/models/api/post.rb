module API
  class Post < Dry::Struct
    include DatastoreAdapter
    include Policy
    
    constructor :schema

    attribute :id, Types::UUID
    attribute :creatorId, Types::UUID
    attribute :title, Types::Strict::String.optional
    attribute :description, Types::Strict::String.optional
    attribute :image, Types::Strict::String.optional

    def creator
      @creator ||= API::User.find(creatorId)
    end

    module ClassMethods
      def to_datastore(attrs)
        attrs.transform_keys do |k|
          key = k.to_sym
          if key == :id
            :uuid
          elsif key == :creatorId
            :user_uuid
          else
            key
          end
        end
      end

      def from_datastore(attrs={})
        attrs = attrs.symbolize_keys
        API::Post.new(
          id:          attrs[:uuid],
          title:       attrs[:title],
          description: attrs[:description],
          image:       attrs[:image],
          creatorId:   attrs[:user_uuid]
        )
      end
      
      def by_user(user_id) 
        where(user_uuid: Types::UUID[user_id])
      end
    end
    extend ClassMethods
  end
end
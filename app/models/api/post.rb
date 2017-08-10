module API
  class Post < Dry::Struct
    include DatastoreAdapter
    include Policy
    
    constructor :schema

    attribute :id, Types::Strict::Int
    attribute :creatorId, Types::Strict::Int
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
          if key == :creatorId
            :user_id
          else
            key
          end
        end
      end

      def from_datastore(attrs={})
        attrs = attrs.symbolize_keys
        API::Post.new(
          id:          attrs[:id],
          title:       attrs[:title],
          description: attrs[:description],
          image:       attrs[:image],
          creatorId:   attrs[:user_id]
        )
      end
      
      def by_user(user_id) 
        where(user_id: user_id)
      end
    end
    extend ClassMethods
  end
end
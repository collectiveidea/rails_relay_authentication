module PostAPI
  extend ActiveSupport::Concern

  def to_api
    {
      id: id,
      title: title,
      description: description,
      image: image,
      creatorId: user_id
    }
  end

  module ClassMethods
    def from_api(attrs)
      attrs = attrs.symbolize_keys
      new(
        id: attrs[:id],
        title: attrs[:title],
        description: attrs[:description],
        image: attrs[:image],
        user_id: attrs[:creatorId],
        errors: attrs[:errors] || {}
      )
    end
  end
end
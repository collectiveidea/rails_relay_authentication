module RecordHelpers
  extend ActiveSupport::Concern

  def save!
    save
  end

  def attributes
    values
  end

  module ClassMethods
    def create!(attrs)
      create(attrs)
    end

    def find_by(params)
      self.where(params).first
    end

    def find(id)
      find_by(id: id)
    end

    def get(uuid)
      find_by(uuid: Types::UUID[uuid]) if uuid.present?
    end

    def delete_all
      db[table_name].delete
    end

    def table_name
      name.pluralize.downcase.to_sym
    end
  end
end
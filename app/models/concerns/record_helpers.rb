module RecordHelpers
  extend ActiveSupport::Concern

  def before_create
    self.created_at ||= Time.now
    super
  end

  def before_save
    self.updated_at = Time.now
    super
  end

  module ClassMethods
    def find_by(params)
      self.where(params).first
    end

    def find(id)
      find_by(id: id)
    end

    def get(uuid)
      find_by(uuid: uuid)
    end

    def delete_all
      db[table_name].delete
    end

    def table_name
      name.pluralize.downcase.to_sym
    end
  end
end
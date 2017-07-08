module Uuidable
  extend ActiveSupport::Concern

  included do
    attr_readonly :uuid 
  end

  def uuid
    self[:uuid] || self.class.where(id: id).pluck(:uuid).first
  end
end
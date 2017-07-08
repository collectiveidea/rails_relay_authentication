class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include CamelizeAttributes
  include Uuidable
end

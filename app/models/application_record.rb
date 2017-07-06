class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include CamelizeAttributes

  attr_readonly :uuid 
end

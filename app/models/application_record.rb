class ApplicationRecord < Dry::Struct
  include CamelizeAttributes
  
  DB = Sequel.connect(YAML.load_file(Rails.root.join("config", "database.yml"))[Rails.env]) 

  def self.find_by(args)
    return unless result = DB[self.name.pluralize.downcase.to_sym].where(args).try(:first)
    new result
  end
end

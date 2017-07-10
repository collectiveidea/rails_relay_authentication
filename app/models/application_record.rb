class ApplicationRecord < Dry::Struct
  include CamelizeAttributes
  
  DB = Sequel.connect(YAML.load_file(Rails.root.join("config", "database.yml"))[Rails.env]) 

  def self.find_by(args)
    # return unless you can validate args with the object's schema
    return unless result = DB[self.name.pluralize.downcase.to_sym].where(args).try(:first)
    new result
  end

  def self.find(id)
    find_by(id: id)
  end

  def self.get(uuid)
    find_by(uuid: uuid)
  end
end

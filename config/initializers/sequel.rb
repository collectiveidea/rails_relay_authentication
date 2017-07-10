require "sequel"
Sequel::Model.db = Sequel.connect(YAML.load_file(Rails.root.join("config", "database.yml"))[Rails.env])

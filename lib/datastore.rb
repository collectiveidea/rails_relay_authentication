module Datastore
  module ClassMethods
    def db
      @@db ||= begin
        params = YAML.load_file(Rails.root.join("config", "database.yml"))[Rails.env]
        Sequel.connect(
          :adapter => params['adapter'].sub('postgresql', 'postgres'),
          :host => params['host'],
          :database => params['database'],
          :user => params['user'],
          :password => params['password'],
          :loggers => Rails.logger
        )
      end
    end

    def users
      db[:users]
    end

    def posts
      db[:posts]
    end
  end
  extend ClassMethods
end
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

    def find_by(table, params)
      where(table, params).first
    end

    def where(table, params)
      db[table].where(params)
    end

    def delete_all(table)
      db[table].delete
    end

    def all(table)
      db[table].to_a
    end

    def count(table)
      db[table].count
    end
  end
  extend ClassMethods
end
module Datastore
  class Table
    def initialize(table_name)
      @table_name = table_name.to_sym
    end

    def find(id)
      find_by(id: id)
    end

    def find_by(params)
      where(params).first
    end

    def delete(id)
      where(id: id).delete
    end

    def delete_all
      table.delete
    end

    def where(params)
      table.where(params)
    end

    def insert(params)
      id = where(id: id).insert(params)
      table[id: id]
    end

    def update(id, params)
      where(id: id).update(params)
      table[id: id]
    end

    def first
      table.first
    end

    def all
      table.to_a
    end

    def count
      table.count
    end

    private

    def table
      Datastore.db[@table_name]
    end
  end

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

    def hashids
      @hashids ||= Hashids.new(Rails.application.secrets.secret_key_base)
    end

    def posts
      Table.new(:posts)
    end

    def users
      Table.new(:users)
    end

    def password_resets
      Table.new(:password_resets)
    end
  end
  extend ClassMethods
end
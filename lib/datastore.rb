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

    #######
    # Methods that need hashid translation
    #######

    def where(params)
      query_params = convert_ids(params, :from_hashid)
      table.where(query_params).map do |record|
        convert_ids(record, :to_hashid)
      end
    end

    def insert(params)
      attrs = convert_ids(params, :from_hashid)
      id = table.insert(attrs)
      convert_ids(table[id: id], :to_hashid)
    end

    def update(id, params)
      id = from_hashid(id)
      attrs = convert_ids(params, :from_hashid)
      table.where(id: id).update(attrs)
      convert_ids(table[id: id], :to_hashid)
    end

    def delete(params)
      query_params = convert_ids(params, :from_hashid)
      table.where(query_params).delete
    end

    def all
      table.to_a.map do |record|
        convert_ids(record, :to_hashid)
      end
    end

    def first
      convert_ids(table.first, :to_hashid)
    end

    #######

    def delete_all
      table.delete
    end

    def count
      table.count
    end

    private

    def table
      Datastore.db[@table_name]
    end

    def convert_ids(params, conversion_method)
      Hash[
        params.map do |k, v|
          key = k.to_sym
          if (key == :id) || !!(k.to_s =~ /_id$/)
            [key, send(conversion_method, v)]
          else
            [key, v]
          end
        end
      ]
    end

    def to_hashid(id)
      Datastore.hashids.encode(id)
    end

    def from_hashid(hashid)
      Datastore.hashids.decode(hashid)
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
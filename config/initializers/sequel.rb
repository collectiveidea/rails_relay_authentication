require "sequel"
class SequelConnector
  def initialize(env)
    @env = env
    @params = YAML.load_file(Rails.root.join("config", "database.yml"))[env]
  end

  def connect_database!
    Sequel.connect(
      :adapter => @params['adapter'].sub('postgresql', 'postgres'),
      :host => @params['host'],
      :database => @params['database'],
      :user => @params['user'],
      :password => @params['password'],
      :loggers => Rails.logger
    )
  end
end

SequelConnector.new(Rails.env).connect_database!

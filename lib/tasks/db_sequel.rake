namespace :db do
  require "sequel"
  Sequel.extension :migration

  DB = Sequel.connect(YAML.load_file(Rails.root.join("config", "database.yml"))[Rails.env])
  DB.extension :schema_dumper
  DB.extension :pretty_table

  MIGRATION_DIR = Rails.root.join("db", "migrate")

  desc "Prints current schema version"
  task :version do    
    version = if DB.tables.include?(:schema_info)
      DB[:schema_info].first[:version]
    end || 0

    puts "Schema Version: #{version}"
  end

  desc "Perform migration up to latest migration available"
  task :migrate do
    Sequel::Migrator.run(DB, MIGRATION_DIR)
    #Rake::Task['db:version'].execute
  end
    
  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, :target do |t, args|
    args.with_defaults(:target => 0)

    Sequel::Migrator.run(DB, MIGRATION_DIR, :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc "Perform migration reset (full rollback and migration)"
  task :reset do
    Sequel::Migrator.run(DB, MIGRATION_DIR, target: 0)
    Sequel::Migrator.run(DB, MIGRATION_DIR)
    Rake::Task['db:version'].execute
  end   

  desc "Seed the db"
  task seed: :environment do
    load Rails.root.join("db", "seeds.rb")
  end    
   

  namespace :schema do
    desc "Dumps the schema to db/schema.db"
    task :dump do
      schema = DB.dump_schema_migration
      File.open(Rails.root.join('db', 'schema.rb'), "w"){|f| f.write(schema)}
    end
  end
end
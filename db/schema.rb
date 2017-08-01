Sequel.migration do
  change do
    create_table(:schema_migrations) do
      column :filename, "text", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:users) do
      primary_key :id
      column :uuid, "uuid", :default=>Sequel::LiteralString.new("uuid_generate_v4()"), :null=>false
      column :email, "text", :null=>false
      column :first_name, "text"
      column :last_name, "text"
      column :role, "integer", :default=>0
      column :password_digest, "text", :default=>"", :null=>false
      column :created_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :updated_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      
      index [:email], :unique=>true
      index [:uuid], :unique=>true
    end
    
    create_table(:password_resets) do
      primary_key :id
      foreign_key :user_uuid, :users, :type=>"uuid", :null=>false, :key=>[:uuid]
      column :token, "text", :null=>false
      column :created_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :expires_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      
      index [:token]
      index [:user_uuid], :unique=>true
    end
    
    create_table(:posts) do
      primary_key :id
      column :uuid, "uuid", :default=>Sequel::LiteralString.new("uuid_generate_v4()"), :null=>false
      foreign_key :user_uuid, :users, :type=>"uuid", :null=>false, :key=>[:uuid]
      column :title, "text"
      column :image, "text"
      column :description, "text"
      column :created_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :updated_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      
      index [:user_uuid]
      index [:uuid], :unique=>true
    end
  end
end
              Sequel.migration do
                change do
                  self << "SET search_path TO \"$user\", public"
                  self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20170703231550_add_devise_to_users.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20170703232325_create_post.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20170728203514_create_password_reset.rb')"
                end
              end

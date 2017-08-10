Sequel.migration do
  change do
    create_table(:schema_migrations) do
      column :filename, "text", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:users) do
      column :id, "bigint", :default=>Sequel::LiteralString.new("next_id()"), :null=>false
      column :email, "text", :null=>false
      column :first_name, "text"
      column :last_name, "text"
      column :role, "integer", :default=>0
      column :password_digest, "text", :default=>"", :null=>false
      column :created_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :updated_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      
      primary_key [:id]
      
      index [:email], :unique=>true
    end
    
    create_table(:password_resets) do
      column :id, "bigint", :default=>Sequel::LiteralString.new("next_id()"), :null=>false
      foreign_key :user_id, :users, :type=>"bigint", :null=>false, :key=>[:id]
      column :token, "text", :null=>false
      column :created_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :expires_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      
      primary_key [:id]
      
      index [:token], :unique=>true
      index [:user_id], :unique=>true
    end
    
    create_table(:posts) do
      column :id, "bigint", :default=>Sequel::LiteralString.new("next_id()"), :null=>false
      foreign_key :user_id, :users, :type=>"bigint", :null=>false, :key=>[:id]
      column :title, "text"
      column :image, "text"
      column :description, "text"
      column :created_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :updated_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      
      primary_key [:id]
      
      index [:user_id]
    end
  end
end
              Sequel.migration do
                change do
                  self << "SET search_path TO \"$user\", public"
                  self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20170703231450_prepare_database.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20170703231550_add_devise_to_users.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20170703232325_create_post.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20170728203514_create_password_reset.rb')"
                end
              end

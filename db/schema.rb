Sequel.migration do
  change do
    create_table(:schema_migrations) do
      String :filename, :text=>true, :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:users, :ignore_index_errors=>true) do
      primary_key :id
      String :uuid, :null=>false
      String :email, :text=>true, :null=>false
      String :first_name, :text=>true
      String :last_name, :text=>true
      String :password_digest, :default=>"", :text=>true, :null=>false
      String :authentication_token, :text=>true
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
      
      index [:authentication_token], :unique=>true
      index [:email], :unique=>true
      index [:uuid], :unique=>true
    end
    
    create_table(:posts, :ignore_index_errors=>true) do
      primary_key :id
      String :uuid, :null=>false
      foreign_key :user_id, :users, :key=>[:id]
      String :title, :text=>true
      String :image, :text=>true
      String :description, :text=>true
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
      
      index [:user_id]
      index [:uuid], :unique=>true
    end
  end
end

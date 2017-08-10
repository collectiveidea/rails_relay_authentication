Sequel.migration do
  up do
    create_table :users do
      Bignum  :id, primary_key: true, null: false
      String  :email, null: false
      String  :first_name
      String  :last_name
      Integer :role, default: 0
      String :password_digest, null: false, default: ""

      column :created_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :updated_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false

      index [:email], unique: true
     end

    extension :pg_triggers

    pgt_created_at(
      :users,
      :created_at,
      :function_name=>:users_set_created_at,
      :trigger_name=>:set_created_at
    )

    pgt_updated_at(
      :users,
      :updated_at,
      :function_name=>:users_set_updated_at,
      :trigger_name=>:set_updated_at
    )
  end

  down do
    drop_trigger(:users, :set_created_at)
    drop_function(:users_set_created_at)

    drop_trigger(:users, :set_updated_at)
    drop_function(:users_set_updated_at)
    
    drop_table(:users)
  end
end

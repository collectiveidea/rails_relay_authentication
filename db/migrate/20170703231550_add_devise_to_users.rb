Sequel.migration do
  up do
    run 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'

    create_table :users do
      primary_key :id, Bignum
      uuid :uuid, null: false, default: Sequel.function(:uuid_generate_v4)
      String  :email, null: false
      String  :first_name
      String  :last_name
      Integer :role, default: 0
      String :password_digest, null: false, default: ""
      String :authentication_token

      DateTime :created_at, null: false, default: Sequel.function(:now)
      DateTime :updated_at, null: false, default: Sequel.function(:now)

      index [:uuid], unique: true
      index [:email], unique: true
      index [:authentication_token],  unique: true   
     end

    extension :pg_triggers

    pgt_created_at(
      :users,
      :created_at,
      :function_name=>:users_set_created_at,
      :trigger_name=>:set_created_at
    )
  end

  down do
    drop_table(:users)
    drop_trigger(:users, :set_created_at)
    drop_function(:users_set_created_at)
  end
end

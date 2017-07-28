Sequel.migration do
  up do
    create_table :password_resets do
      primary_key :id, Bignum
      foreign_key :user_uuid, :users, key: :uuid, type: :uuid, null: false
      String :token, null: false

      column :created_at, "timestamp with time zone", default: Sequel::CURRENT_TIMESTAMP, null: false
      column :expires_at, "timestamp with time zone", default: Sequel.lit("now() + '1 week'"), null: false

      index [:user_uuid]
      index [:token]
    end

    extension :pg_triggers

    pgt_created_at(
      :password_resets,
      :created_at,
      :function_name=>:password_resets_set_created_at,
      :trigger_name=>:set_created_at
    )
  end

  down do
    drop_trigger(:password_resets, :set_created_at)
    drop_function(:password_resets_set_created_at)
    drop_table(:password_resets)
  end
end

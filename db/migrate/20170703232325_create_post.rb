Sequel.migration do
  up do
    create_table :posts do
      primary_key :id, Bignum
      uuid :uuid, null: false, default: Sequel.function(:uuid_generate_v4)
      foreign_key :user_id, :users, key: :uuid, type: :uuid, null: false
      String :title
      String :image
      Text :description

      column :created_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :updated_at, "timestamp with time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false

      index [:uuid], unique: true
      index [:user_id]
     end

    extension :pg_triggers

    pgt_created_at(
      :posts,
      :created_at,
      :function_name=>:posts_set_created_at,
      :trigger_name=>:set_created_at
    )

    pgt_updated_at(
      :posts,
      :updated_at,
      :function_name=>:posts_set_updated_at,
      :trigger_name=>:set_updated_at
    )
  end

  down do
    drop_trigger(:posts, :set_created_at)
    drop_function(:posts_set_created_at)

    drop_trigger(:posts, :set_updated_at)
    drop_function(:posts_set_updated_at)

    drop_table(:posts)
  end
end

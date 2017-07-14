Sequel.migration do
  up do
    create_table :posts do
      primary_key :id, Bignum
      uuid :uuid, null: false, default: Sequel.function(:uuid_generate_v4)
      foreign_key :user_id, :users, key: :id 
      String :title
      String :image
      Text :description

      DateTime :created_at, null: false, default: Sequel.function(:now)
      DateTime :updated_at, null: false, default: Sequel.function(:now)

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

  end

  down do
    drop_table(:posts)
    drop_trigger(:posts, :set_created_at)
    drop_function(:posts_set_created_at)
  end
end

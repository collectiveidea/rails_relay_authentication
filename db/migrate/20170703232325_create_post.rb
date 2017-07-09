Sequel.migration do
  up do
    create_table :posts do
      primary_key :id, Bignum
      uuid :uuid, null: false, default: Sequel.function(:uuid_generate_v4)
      foreign_key :user_id, :users, key: :id 
      String :title
      String :image
      Text :description

      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:uuid], unique: true
      index [:user_id]
     end
  end

  down do
    drop_table(:posts)
  end
end

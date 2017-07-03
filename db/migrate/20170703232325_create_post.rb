class CreatePost < ActiveRecord::Migration[5.1]
  def change
    create_table :posts, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.uuid :user_id, null: false
      t.string :title
      t.string :image
      t.text :description
      t.timestamps null: false
    end
  end
end

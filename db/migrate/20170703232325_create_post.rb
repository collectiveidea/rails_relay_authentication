class CreatePost < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.references :user,       null: false, index: true
      
      t.uuid       :uuid,       null: false, default: 'uuid_generate_v4()'
      t.string     :title
      t.string     :image
      t.text       :description

      t.timestamps              null: false

      t.index      :uuid,       unique: true
    end
  end
end

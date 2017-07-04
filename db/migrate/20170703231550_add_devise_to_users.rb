class AddDeviseToUsers < ActiveRecord::Migration[5.1]
  def self.up
    enable_extension "uuid-ossp"

    create_table :users do |t|
      t.uuid    :uuid,                null: false, default: 'uuid_generate_v4()'
      t.string  :email,               null: false
      t.integer :role,                null: false, default: 0
      t.string  :first_name
      t.string  :last_name

      t.string :password_digest,      null: false, default: ""
      t.string :authentication_token

      t.timestamps null: false

      t.index :uuid,                  unique: true
      t.index :email,                 unique: true
      t.index :authentication_token,  unique: true
    end
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    drop_table :users
  end
end

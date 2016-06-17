class CreateAccountUsers < ActiveRecord::Migration
  def change
    create_table :account_users do |t|
      t.references :account
      t.references :user
      t.text :permissions

      t.timestamps
    end
    add_index :account_users, :account_id
    add_index :account_users, :user_id
  end
end

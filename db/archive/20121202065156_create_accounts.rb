class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user
      t.string :name
      t.string :phone_home
      t.string :phone_work
      t.string :phone_mobile
      t.text :address_street
      t.string :address_city
      t.string :address_state
      t.string :address_zip
      t.string :company_name
      t.text :company_website

      t.timestamps
    end
    add_index :accounts, :user_id
  end
end

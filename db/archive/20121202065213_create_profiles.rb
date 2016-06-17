class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user
      t.string :name_first
      t.string :name_middle
      t.string :name_last
      t.string :phone_home
      t.string :phone_work
      t.string :phone_mobile
      t.text :address_street
      t.string :address_city
      t.string :address_state
      t.string :address_zip
      t.string :company_name
      t.text :company_website
      t.string :job_title
      t.text :job_description
      t.text :profile_description

      t.timestamps
    end
    add_index :profiles, :user_id
  end
end

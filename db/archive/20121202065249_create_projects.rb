class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :account
      t.references :invoice
      t.string :category
      t.string :title
      t.text :description
      t.string :status
      t.date :start
      t.date :end

      t.timestamps
    end
    add_index :projects, :account_id
    add_index :projects, :invoice_id
  end
end

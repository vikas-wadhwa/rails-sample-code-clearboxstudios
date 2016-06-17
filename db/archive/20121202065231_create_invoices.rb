class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :account
      t.string :category
      t.string :title
      t.text :description
      t.integer :status
      t.date :bill_date
      t.date :payment_date

      t.timestamps
    end
    add_index :invoices, :account_id
  end
end

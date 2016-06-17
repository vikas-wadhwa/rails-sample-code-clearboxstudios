class ChangeDatatypeForStatus < ActiveRecord::Migration
  def self.up
    change_table :invoices do |t|
      t.change :status, :string
    end
  end
  
  def self.down
    change_table :invoices do |t|
      t.change :status, :integer
    end
  end
end

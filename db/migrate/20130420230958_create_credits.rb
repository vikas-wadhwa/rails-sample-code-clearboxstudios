class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.string :area
      t.string :department
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end

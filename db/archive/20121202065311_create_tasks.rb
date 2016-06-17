class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :project
      t.integer :staff_id
      t.string :category
      t.string :title
      t.text :description
      t.string :status
      t.decimal :hours_estimate
      t.decimal :rate_estimate
      t.decimal :rate_actual
      t.decimal :staff_rate_estimate
      t.decimal :staff_rate_actual
      t.date :start
      t.date :end

      t.timestamps
    end
    add_index :tasks, :project_id
  end
end

class CreateProjectPhotos < ActiveRecord::Migration
  def change
    create_table :project_photos do |t|
      t.references :project

      t.timestamps
    end
    add_index :project_photos, :project_id
  end
end

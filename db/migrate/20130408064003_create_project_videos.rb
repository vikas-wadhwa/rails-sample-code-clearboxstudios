class CreateProjectVideos < ActiveRecord::Migration
  def change
    create_table :project_videos do |t|
      t.references :project

      t.timestamps
    end
    add_index :project_videos, :project_id
  end
end

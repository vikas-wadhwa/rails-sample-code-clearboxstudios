class AddDetailsToProjectVideos < ActiveRecord::Migration
  def change
    add_column :project_videos, :video_type, :string
    add_column :project_videos, :title, :string
    add_column :project_videos, :description, :text
    add_column :project_videos, :duration, :integer
  end
end

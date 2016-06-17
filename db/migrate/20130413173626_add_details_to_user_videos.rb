class AddDetailsToUserVideos < ActiveRecord::Migration
  def change
    add_column :user_videos, :video_type, :string
    add_column :user_videos, :title, :string
    add_column :user_videos, :description, :text
    add_column :user_videos, :duration, :integer
  end
end

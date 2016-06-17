class AddAttachmentVideoToProjectVideos < ActiveRecord::Migration
  def self.up
    change_table :project_videos do |t|
      t.attachment :video
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :project_videos, :video
  end
end

class AddAttachmentVideoToUserVideos < ActiveRecord::Migration
  def self.up
    change_table :user_videos do |t|
      t.attachment :video
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :user_videos, :video
  end
end

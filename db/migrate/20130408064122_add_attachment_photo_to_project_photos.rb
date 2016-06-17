class AddAttachmentPhotoToProjectPhotos < ActiveRecord::Migration
  def self.up
    change_table :project_photos do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :project_photos, :photo
  end
end

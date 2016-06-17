class AddCapturedFilenameToProjectPhotos < ActiveRecord::Migration
  def change
    add_column :project_photos, :captured_filename, :string
  end
end

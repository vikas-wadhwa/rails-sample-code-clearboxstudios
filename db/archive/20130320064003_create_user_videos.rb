class CreateUserVideos < ActiveRecord::Migration
  def change
    create_table :user_videos do |t|
      t.references :user

      t.timestamps
    end
    add_index :user_videos, :user_id
  end
end

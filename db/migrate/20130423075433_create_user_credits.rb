class CreateUserCredits < ActiveRecord::Migration
  def change
    create_table :user_credits do |t|
      t.references :user
      t.references :user_video
      t.references :credit
      t.text :notes

      t.timestamps
    end
    add_index :user_credits, :user_id
    add_index :user_credits, :user_video_id
    add_index :user_credits, :credit_id
  end
end

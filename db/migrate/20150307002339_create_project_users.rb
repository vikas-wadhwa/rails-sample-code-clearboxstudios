class CreateProjectUsers < ActiveRecord::Migration
  def change

    create_table "project_users", :force => true do |t|
      t.integer  "project_id"
      t.integer  "user_id"
      t.text     "permissions"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    add_index "project_users", ["project_id"], :name => "index_project_users_on_project_id"
    add_index "project_users", ["user_id"], :name => "index_project_users_on_user_id"


  end
end

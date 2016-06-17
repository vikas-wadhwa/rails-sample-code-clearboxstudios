class CreateUserDocuments < ActiveRecord::Migration
  def change
    create_table :user_documents do |t|
      t.references :user

      t.timestamps
    end
    add_index :user_documents, :user_id
  end
end

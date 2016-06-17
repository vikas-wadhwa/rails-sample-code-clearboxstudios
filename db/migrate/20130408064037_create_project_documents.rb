class CreateProjectDocuments < ActiveRecord::Migration
  def change
    create_table :project_documents do |t|
      t.references :project

      t.timestamps
    end
    add_index :project_documents, :project_id
  end
end

class AddAttachmentDocumentToProjectDocuments < ActiveRecord::Migration
  def self.up
    change_table :project_documents do |t|
      t.attachment :document
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :project_documents, :document
  end
end

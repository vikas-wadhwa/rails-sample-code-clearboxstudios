class AddAttachmentDocumentToUserDocuments < ActiveRecord::Migration
  def self.up
    change_table :user_documents do |t|
      t.attachment :document
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :user_documents, :document
  end
end

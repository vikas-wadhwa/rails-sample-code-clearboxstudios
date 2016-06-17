class AddClientContactIdAndInternalContactIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :client_contact_id, :string
    add_column :projects, :internal_contact_id, :string
  end
end

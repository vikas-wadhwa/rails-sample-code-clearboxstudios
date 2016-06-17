class AddImageLinksToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :image_links, :hstore
  end
end

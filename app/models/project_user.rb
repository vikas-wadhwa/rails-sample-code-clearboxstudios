class ProjectUser < ActiveRecord::Base

  belongs_to :project
  belongs_to :user

  attr_accessible :user_id, :project_id, :permissions

end

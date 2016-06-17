class AboutController < ApplicationController

  def assign_constants
  end

  def index
    assign_constants
    @staff_users = User.staff_members.includes(:profile, :photos).sort_by(&:id)
  end


end

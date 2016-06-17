class UserCredit < ActiveRecord::Base

  ################################################
  # setup relationships
  ################################################
  belongs_to :user
  belongs_to :user_video
  belongs_to :credit
  attr_accessible :user_id, :user_video_id, :credit_id, :credits_attributes, :notes




  scope :search_by_credit, lambda { |query|
    select('user_id, count(user_id) as credit_count').uniq.joins(:credit).where('user_credits.user_id is not null and credits.title ILIKE ? ', '%' + query + '%').group(:user_id).order("credit_count DESC")
  }

  def title
    self.credit.title
  end

  def self.find_by_title(string)
    joins(:credit).where('credits.title = ?', string)
  end

  def user_full_name
    
    if self.user && self.user.profile
      self.user.profile.full_name.nvl('userid: ' + self.user.id.to_s)
    
    elsif self.user
      'userid: ' + self.user.id.to_s
    
    else
      ''
    end
  
  end

end
class Credit < ActiveRecord::Base


  ################################################
  # class callbacks
  ################################################



  ################################################
  # setup relationships
  ################################################
  # relate to user_credits
  has_many :user_credits
  attr_accessible :area, :title, :department, :description
  
  
  ################################################
  # Postgres searching
  ################################################
  include PgSearch
  multisearchable :against => [:area, :title, :department, :description]
  
  def self.default_credits
    where(:title => ['Producer','Director','Actor'])
  end
  
end

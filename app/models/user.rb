class User < ActiveRecord::Base

  ################################################
  # class callbacks
  ################################################
  include AwsMethods
  include FileSystemPaths
  after_destroy :cleanup
  after_create :create_profile

  ################################################
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable and :omniauthable
  ################################################
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable


  ################################################
  # Setup accessible (or protected) attributes for your model. Others available are:
  # attr_accessible :title, :body
  ################################################
  attr_accessible :email, :password, :password_confirmation, :remember_me

  ################################################
  # setup relationships
  ################################################

  # relate to profiles
  has_one :profile
  accepts_nested_attributes_for :profile, :allow_destroy => :true

  # relate to tasks
  has_many :tasks, :class_name => 'Task', :foreign_key => 'staff_id'

  # relate to attachments
  has_many :documents, :class_name => 'UserDocument'
  has_many :photos, :class_name => 'UserPhoto'
  has_many :videos, :class_name => 'UserVideo'
  has_many :user_credits
  has_many :credits, :through => :user_credits

  # relate to accounts
  has_many :account_users
  has_many :accounts, :through => :account_users


  # relate to invoices
  has_many :invoices, :through => :accounts, :autosave => false


  # relate to projects
  #has_many :projects, :through => :accounts #, :conditions => { :active => 1 }, :autosave => false
  has_many :project_users
  has_many :projects, :through => :project_users


  ################################################
  # setup scopes
  ################################################
  #scope :staff_members, {:conditions => ["email LIKE ?", "%@clearboxstudios.com"]}

  scope :staff_members,lambda{ joins(:profile).merge(Profile.staff_members) }


  ################################################
  # setup methods
  ################################################

  def staff_member?
    self.profile.staff_member
  end


  ################################################
  # setup confirmation email actions
  ################################################  

  def headers_for(action)
    if action == :confirmation_instructions
      { bcc: "accounts@clearboxstudios.com", subject: "Welcome to ClearBox Studios! Please Confirm your membership." }
    else
      {}
    end
  end


  private
  ################################################
  # create profile
  ################################################
  #
  # def create_profile
  #
  #   if self.confirmed_at_changed? && self.profile.nil?
  #     self.profile = Profile.new
  #     self.profile.save
  #   end
  #
  # end




  ################################################
  # cleanup
  ################################################

  def cleanup
    self.profile.destroy if self.profile
  end







end

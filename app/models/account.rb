class Account < ActiveRecord::Base

  ################################################
  # class callbacks
  ################################################


  ################################################
  # setup relationships
  ################################################

  # relate to users
  has_many :account_users, :dependent => :delete_all
  has_many :users, :through => :account_users

  # relate to invoices
  has_many :invoices
  
  # relate to projects
  has_many :projects

  # relate to tasks
  has_many :tasks, :through => :projects


  # setup accessible columns
  attr_accessible :company_phone, :company_address_street, :company_address_city, 
                  :company_address_state, :company_address_zip, :company_name, :company_website, 
                  :billing_name, :billing_email, :billing_phone_home, :billing_phone_work, :billing_phone_mobile, 
                  :billing_address_street, :billing_address_city, :billing_address_state, :billing_address_zip, 
                  :name, :permissions

  validates_presence_of :billing_name, :billing_email, :name


                        
  ################################################
  # Postgres searching
  ################################################
  include PgSearch
  multisearchable :against => [:id, :company_phone, :company_address_street, :company_address_city, 
                                :company_address_state, :company_address_zip, :company_name, :company_website, 
                                :billing_name, :billing_email, :billing_phone_home, :billing_phone_work, :billing_phone_mobile, 
                                :billing_address_street, :billing_address_city, :billing_address_state, :billing_address_zip, 
                                :name]



  
  ################################################
  # permissions
  ################################################

  def access_level(x)
    if x==0
      'none'
    elseif x==1
      'read'
    elseif x==2
      'update'
    end
  end

  def account_access
    self.permissions[1,1]
  end
  
  def world_access
    self.permissions[2,1]
  end

  # readable
  def self.user_readable(user, *account_ids)


    # Allow staff members to view any account media
    if user.profile.staff_member
      readable = Account.all.order(:company_name, :name)
    else
      readable = user.accounts.order(:company_name, :name).find_by_id *account_ids
    end


    return readable

  end
  
  def self.account_readable(account)
    user.accounts
  end
  
  # updateable
  def self.user_updateable(user)
    user.accounts
  end
  
  def self.account_updateable(account)
    where('permissions % 10 > 10')
  end
  
  # destroyable
  def destroyable?
    self.projects.present?
  end


  def user_readable(user)
    if user.profile.staff_member? || self == user.accounts.find_by_id(self.id)
      return true
    else
      return false
    end
  end

  def user_editable(user)
    user.profile.staff_member?
  end


  ################################################
  # define enumerated column arrays
  ################################################

  def thumbnail_url
  
    PLACEHOLDER_PROJECT_IMAGE_URL

  end
  

end

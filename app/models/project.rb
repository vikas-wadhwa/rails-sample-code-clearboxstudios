class Project < ActiveRecord::Base
  extend UnionHack

  ################################################
  # class callbacks
  ################################################
  #default_scope where("removed_at IS NULL")
  after_destroy :cleanup
  after_initialize :set_defaults

  ################################################
  # setup relationships
  ################################################

  # relate to accounts
  belongs_to :account

  # relate to invoices
  belongs_to :invoice

  # relate to tasks
  has_many :tasks, :dependent => :destroy

  # relate to users
  has_many :project_users, :dependent => :destroy
  has_many :users, :through => :project_users

  # relate to attachments
  has_many :documents, :class_name => 'ProjectDocument', :dependent => :destroy
  has_many :images, :class_name => 'ProjectPhoto', :dependent => :destroy
  has_many :videos, :class_name => 'ProjectVideo', :dependent => :destroy


  ################################################
  # setup accessible columns
  ################################################
  attr_accessible :account_id, :invoice_id, :description,
                  :end, :permissions, :start, :status, :title, :category, :image_links

  validates_presence_of :account_id, :description, :start, :status, :title, :category


  ################################################
  # setup scopes
  ################################################

  scope :unbilled, -> { where(invoice_id: nil) }


  ################################################
  # Postgres searching
  ################################################
  include PgSearch
  pg_search_scope :search_for,  :against => [:id, :description, :end, :start, :status, :title, :category]


  ################################################
  # define enumerated column arrays
  ################################################
  ENUMERATIONS = {
      categories: ['Internal', 'Billable', 'Contest', 'Other'],
      status: ['Planning', 'Active', 'Complete', 'Invoiced'],
      permission: ['Can read','Can update']
  }


  def set_defaults
    self.image_links ||= {}
  end



  ################################################
  ## Readable
  ################################################
  def self.user_readable(user, *project_ids)

    # Allow staff members to view any project media
    if user.profile.staff_member?
      readable = Project.all
    else
      readable = user.projects
    end

    # List the latest updated projects first
    readable = readable.order(:updated_at).reverse_order
    readable = readable.find_by_id *project_ids unless project_ids.empty?

    return readable

  end

  def self.account_readable(account)
    account.projects
  end

  def self.public_readable
    where('permissions % 10 > 0')
  end


  ################################################
  ## Editable
  ################################################
  def self.user_editable(user, *project_ids)

    # Allow staff members to view any project media
    if user.profile.staff_member?
      if project_ids.empty?
        editable = Project.all

      else
        editable = Project.find_by_id *project_ids
      end
    end

    return editable
  end

  def self.account_editable(account)
    where('permissions % 10 > 10')
  end


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

  def destroyable?
    self.status == 'Planning' || 'Active'
  end

  def user_readable(user)
    user.profile.staff_member? || self == user.projects.find(self)
  end

  def user_editable(user)
    user.profile.staff_member?
  end



  ################################################
  # setup methods
  ################################################
  def create_default_tasks

    Task.default_tasks.each do |key, default|
      t = self.tasks.new(default)
      t.start = self.start
      t.end = self.end
      t.save
    end

  end

  def create_duplicate_tasks(original_project)

    if original_project.tasks.present?
      original_project.tasks.each do |task|
        t = task.dup
        t.project_id = self.id
        t.start = self.start
        t.end = self.end
        t.save
      end

    else create_default_tasks

    end

  end


  def cleanup
    #self.tasks.destroy if self.tasks
  end


  ################################################
  # setup AWS filesystem bucket methods
  ################################################
  PLACEHOLDER_IMAGE_URL =  "#{AWS_CDN_PUBLIC_URL}/placeholder/placeholder-photo.jpg"
  PLACEHOLDER_VIDEO_IMAGE_URL =  "#{AWS_CDN_PUBLIC_URL}/placeholder/placeholder-video.jpg"
  include FileSystemPaths

  def image_url(style)

    if self.images.any?
      self.images.first.image.url(style)

    elsif self.videos.any?
      self.videos.first.image.url(style)

    else
      PLACEHOLDER_IMAGE_URL
    end

  rescue ActiveRecord::RecordNotFound
    PLACEHOLDER_IMAGE_URL
  end



end

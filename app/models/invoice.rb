class Invoice < ActiveRecord::Base


  ################################################
  # class callbacks
  ################################################


  ################################################
  # setup relationships
  ################################################

  # relate to accounts
  belongs_to :account


  # relate to projects
  has_many :projects
  accepts_nested_attributes_for :projects

  # relate to tasks
  has_many :tasks, :through => :projects

  ################################################
  # setup accessible columns
  ################################################
  attr_accessible :account_id, :bill_date, :description, :payment_date, :status, :title, :category
  validates_presence_of :bill_date, :description, :status, :title, :category

  ################################################
  # Postgres searching
  ################################################
  include PgSearch
  pg_search_scope :search_for,  :against => [:id, :account_id, :bill_date, :description, :payment_date, :status, :title, :category]


  ################################################
  # define enumerated column arrays
  ################################################

  ENUMERATIONS = {
      categories: ['Receivable', 'Payable'],
      status: ['Unbilled', 'Unpaid', 'Paid'],
      permission: ['Can read','Can update']
  }

  def paid?
    self.status == 'Paid'
  end

  def unpaid?
    self.status != 'Paid'
  end


  def amount_due
    self.tasks.sum('rate_actual * hours_actual').to_i
  end

  def image_url(style)

    if self.projects.any?
      self.projects.first.image_url(style)
    else
      PLACEHOLDER_PROJECT_IMAGE_URL
    end

  rescue ActiveRecord::RecordNotFound
    PLACEHOLDER_PROJECT_IMAGE_URL
  end


  def tasks_grouped
    results = self.tasks.sort_by &:created_at
    results.group_by {|task| task.task_type.downcase }
  end



  ################################################
  # permissions
  ################################################

  ##### readable
  def self.user_readable(user, *invoice_ids)

    # Allow staff members to view any invoice media
    if user.profile.staff_member?
      readable = Invoice.all
    else
      readable = user.invoices
    end

    # List the latest updated invoices first
    readable = readable.order(:updated_at).reverse_order
    readable = readable.find_by_id *invoice_ids unless invoice_ids.empty?

    return readable

  end

  def user_readable(user)
    user.profile.staff_member? || self == user.invoices.find(self)
  end

  def user_editable(user)
    user.profile.staff_member?
  end



end

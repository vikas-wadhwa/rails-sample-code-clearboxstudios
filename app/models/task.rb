class Task < ActiveRecord::Base


  ################################################
  # class callbacks
  ################################################


  ################################################
  # setup relationships
  ################################################

  # relate to projects
  belongs_to :project
  
  # relate to accounts
  belongs_to :account

  # relate to invoice
  belongs_to :invoice

  # relate to staff users
  belongs_to :staff, :class_name => User


  ################################################
  # setup accessible columns
  ################################################
  attr_accessible :hours_estimate, :hours_actual, :rate_actual, :rate_estimate, 
                  :description, :end, :staff_id, :staff_rate_actual, :staff_rate_estimate, 
                  :start, :status, :title, :category, :task_type

  validates_presence_of :description, :start, :status, :title, :category, :task_type

  ################################################
  # Postgres searching
  ################################################
  include PgSearch
  multisearchable :against => [:id, :hours_estimate, :hours_actual, :rate_actual, :rate_estimate, 
                                :description, :end, :staff_id, :staff_rate_actual, :staff_rate_estimate, 
                                :start, :status, :title, :category, :task_type]




  ################################################
  # define enumerated column arrays
  ################################################

  ENUMERATIONS = {
      task_type: ['Full day','Half day', 'Hourly', 'Fixed'],
      categories: ['Pre-production', 'Production', 'Post-production','Expense'],
      status: ['Unassigned', 'In Progress', 'Needs Approval', 'Complete'],
      permission: ['Can read','Can update']
  }


  def self.default_tasks

    defaults = {
                :preproduction=>{},
                :production_crew=>{}, 
                :production_talent=>{}, 
                :production_makeup=>{}, 
                :production_equipment=>{}, 
                :production_location=>{}, 
                :production_insurance=>{},  
                :postproduction_voiceover=>{}, 
                :postproduction_talent=>{},
                :postproduction_editor=>{}, 
                :postproduction_graphic_artist=>{},
                :postproduction_licensing =>{}      
      }
    
    defaults[:preproduction][:category] ='Pre-production'
    defaults[:preproduction][:title] ='Storyboarding and Writing'
    defaults[:preproduction][:description] ='Pre-production planning, screenwriting, and storyboard art.'
    defaults[:preproduction][:status] ='Unassigned'
    defaults[:preproduction][:task_type] ='Hourly'

    defaults[:production_crew][:category] ='Production'
    defaults[:production_crew][:title] ='Production Crew'
    defaults[:production_crew][:description] ='Location crew work during production.'
    defaults[:production_crew][:status] ='Unassigned'
    defaults[:production_crew][:task_type] ='Hourly'

    defaults[:production_talent][:category] ='Production'
    defaults[:production_talent][:title] ='Talent'
    defaults[:production_talent][:description] ='Talent work during production.'
    defaults[:production_talent][:status] ='Unassigned'
    defaults[:production_talent][:task_type] ='Hourly'
    
    defaults[:production_makeup][:category] ='Production'
    defaults[:production_makeup][:title] ='Makeup'
    defaults[:production_makeup][:description] ='Hair and makeup artist work during production.'
    defaults[:production_makeup][:status] ='Unassigned'
    defaults[:production_makeup][:task_type] ='Hourly'
    
    defaults[:production_equipment][:category] ='Production'
    defaults[:production_equipment][:title] ='Equipment Rental'
    defaults[:production_equipment][:description] ='Equipment rented during production.'
    defaults[:production_equipment][:status] ='Unassigned'
    defaults[:production_equipment][:task_type] ='Fixed'
    
    defaults[:production_location][:category] ='Production'
    defaults[:production_location][:title] ='Location Incidentals'
    defaults[:production_location][:description] ='Location incidentals incurred during production (such as location rental, parking, food, etc).'
    defaults[:production_location][:status] ='Unassigned'
    defaults[:production_location][:task_type] ='Fixed'
    
    defaults[:production_insurance][:category] ='Production'
    defaults[:production_insurance][:title] ='Insurance'
    defaults[:production_insurance][:description] ='Special insurance fees needed during production.'
    defaults[:production_insurance][:status] ='Unassigned'
    defaults[:production_insurance][:task_type] ='Fixed'
    
    defaults[:postproduction_voiceover][:category] ='Post-production'
    defaults[:postproduction_voiceover][:title] ='Voiceover Recording'
    defaults[:postproduction_voiceover][:description] ='Voiceover and additional dialogue recording during post-production.'
    defaults[:postproduction_voiceover][:status] ='Unassigned'
    defaults[:postproduction_voiceover][:task_type] ='Hourly'

    defaults[:postproduction_talent][:category] ='Post-production'
    defaults[:postproduction_talent][:title] ='Voiceover Talent'
    defaults[:postproduction_talent][:description] ='Talent work during post-production voiceover and additional dialogue recording.'
    defaults[:postproduction_talent][:status] ='Unassigned'
    defaults[:postproduction_talent][:task_type] ='Hourly'
    
    defaults[:postproduction_editor][:category] ='Post-production'
    defaults[:postproduction_editor][:title] ='Editor'
    defaults[:postproduction_editor][:description] ='Editing work during post-production.'
    defaults[:postproduction_editor][:status] ='Unassigned'
    defaults[:postproduction_editor][:task_type] ='Hourly'
    
    defaults[:postproduction_graphic_artist][:category] ='Post-production'
    defaults[:postproduction_graphic_artist][:title] ='Graphics Artist'
    defaults[:postproduction_graphic_artist][:description] ='Graphics artist work during post-production.'
    defaults[:postproduction_graphic_artist][:status] ='Unassigned'
    defaults[:postproduction_graphic_artist][:task_type] ='Hourly'
    
    defaults[:postproduction_licensing][:category] ='Post-production'
    defaults[:postproduction_licensing][:title] ='Copyright Licensing'
    defaults[:postproduction_licensing][:description] ='Licensing fees for property used during post-production.'
    defaults[:postproduction_licensing][:status] ='Unassigned'
    defaults[:postproduction_licensing][:task_type] ='Fixed'
    
    return defaults
    
  end

  ################################################
  # define custom returns
  ################################################

  def amount_due
    amount = self.rate_actual * self.hours_actual
    amount.to_i
  end

  def full_day?
    self.full_day? == 'Full day'
  end

  def half_day?
    self.half_day? == 'Half day'
  end

  def hourly?
    self.task_type == 'Hourly'
  end

  def fixed?
    self.task_type == 'Fixed'
  end


  def staff_profile
    # use find_by_id so that it does not throw an error if none found
    @user = User.find_by_id(self.staff_id)

    if @user
      staff_profile = @user.profile
    else
      staff_profile = Profile.new
    end

  end 

  ################################################
  # setup bucket methods
  ################################################
  def default_url
    Profile.find(self.staff_id).photos.first.image.url(:default)
  end

  def project_image_url(style)
    #self.images.find(self.image_links['project_image']).image.url(style)

    self.project.image_url(style)

  rescue ActiveRecord::RecordNotFound
    PLACEHOLDER_PROJECT_IMAGE_URL
  end


  def staff_image_url(style)
    #self.images.find(self.image_links['project_image']).image.url(style)

    if self.staff_profile
      self.staff.profile.image_url(style)
    else
      PLACEHOLDER_PROJECT_IMAGE_URL
    end

  rescue ActiveRecord::RecordNotFound
    PLACEHOLDER_PROJECT_IMAGE_URL
  end


  def media_bucket
    AWS_S3_PROJECTS_BUCKET
  end 


end

class Profile < ActiveRecord::Base

  ################################################
  # class callbacks
  ################################################
  include ApplicationHelper
  after_initialize :set_defaults


  ################################################
  # setup relationships
  ################################################

  # relate to users
  belongs_to :user

  ################################################
  # setup accessible columns
  ################################################
  attr_accessible :address_city, :address_state, :address_street, :address_zip,
                  :company_name, :company_website, :image_links, :job_description, :job_title,
                  :name_first, :name_last, :name_middle,
                  :phone_home, :phone_mobile, :phone_work,
                  :profile_description, :staff_member, :contact_links, :privacy_settings, :image_links

  attr_accessor  :address_city_screened,:address_state_screened,:address_street_screened,:address_zip_screened,
                 :company_name_screened,:company_website_screened,:job_description_screened,
                 :job_title_screened,:name_first_screened,:name_last_screened,:name_middle_screened,
                 :phone_home_screened,:phone_mobile_screened,:phone_work_screened,:profile_description_screened

  #serialize :contact_links, ActiveRecord::Coders::Hstore
  #serialize :image_links, ActiveRecord::Coders::Hstore
  #serialize :privacy_settings, ActiveRecord::Coders::Hstore

  scope :search_by_name, lambda { |query|
    if query
      search_term = "%#{query}%"
      where(["name_first ILIKE ? or name_last ILIKE ? or concat(name_first, ' ', name_last) ILIKE ?",  search_term, search_term, search_term ])
    else
      {}
    end
  }


  scope :filled_out, -> { where.not(name_first: "", name_last: "", profile_description: "") }


  ################################################
  # Postgres searching
  ################################################
  include PgSearch
  multisearchable :against => [
      :id, :name_first,:name_last,:name_middle,:profile_description, :contact_links_string,
      :address_city_screened,:address_state_screened,:address_street_screened,:address_zip_screened,
      :company_name_screened,:company_website_screened,:job_description_screened, :job_title_screened,
      :phone_home_screened,:phone_mobile_screened,:phone_work_screened
  ]

  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end

  ################################################
  # setup scopes and accessors
  ################################################
  def set_defaults

    # since privacy, contact, and images are hashes,
    # they are not necessarily created on profile creation
    # so we check if they exist in the hstore and set them to {} if nil

    self.privacy_settings ||= {}
    self.contact_links ||= {}
    self.image_links ||= {}

    self.name_first = "" unless self.name_first
    self.name_last = "" unless self.name_last
    self.profile_description = "" unless self.profile_description

  end


  ################################################
  # Class methods
  ################################################
  def self.find_image_by_user_id(user_id, style)

    if User.find_by_id(user_id)
      User.find_by_id(user_id).profile.image_url(style)
    else
      PLACEHOLDER_IMAGE_URL
    end
  end

  def self.staff_members
    where(:staff_member => true).where("name_first is not null")
  end

  def self.image_attach_url
    "/user/photos/create"
  end


  ################################################
  # Data manipulation
  ################################################
  def full_name
    full_name = []
    full_name << name_first unless name_first.blank?
    full_name << name_middle unless name_middle.blank?
    full_name << name_last unless name_last.blank?
    full_name.join(" ")
  end

  ################################################
  # Boolean questions
  ################################################
  def filled_out?
    if name_first.blank? || name_last.blank? || profile_description.blank?
      return false
    else
      return true
    end
  end

  def contactable?
    contacts = address_street_screened + address_city_screened + address_state_screened + address_zip_screened + company_name_screened + company_website_screened + phone_home_screened + phone_mobile_screened + phone_work_screened + contact_links_string
    contacts.present?
  end

  def has_address?
    contacts = address_street_screened + address_city_screened + address_state_screened + address_zip_screened
    contacts.present?
  end

  def has_phone?
    contacts = phone_home_screened + phone_mobile_screened + phone_work_screened
    contacts.present?
  end

  def has_social?
    contacts = contact_links_string
    contacts.present?
  end

  def image
    self.user.photos.find(image_id).image
  end

  def video_image
    self.user.videos.find(video_image_id).image
  end

  ################################################
  # setup AWS filesystem bucket methods
  ################################################
  PLACEHOLDER_IMAGE_URL =  "#{AWS_CDN_PUBLIC_URL}/placeholder/placeholder-profile.jpg"
  PLACEHOLDER_VIDEO_IMAGE_URL =  "#{AWS_CDN_PUBLIC_URL}/placeholder/placeholder-video.jpg"
  MEDIA_NAME = "user"
  include FileSystemPaths

  def image_url(style)
    unless image_id.nil?
      image.url(style)
    else
      PLACEHOLDER_IMAGE_URL
    end
  rescue ActiveRecord::RecordNotFound
    PLACEHOLDER_IMAGE_URL
  end


  def video_image_url(style)
    if video_image_id
      video_image.image.url(style)
    else
      PLACEHOLDER_VIDEO_IMAGE_URL
    end
  rescue ActiveRecord::RecordNotFound
    PLACEHOLDER_VIDEO_IMAGE_URL
  end


  ################################################
  # privacy methods
  ################################################

  ##### readable
  def self.user_readable(user, *profile_ids)

    # Allow staff members to view any profile media
    if user.profile.staff_member?
      readable = Profile.all
    else
      readable = Profile.all
    end

    # List the latest updated profiles first
    readable = readable.order(:updated_at).reverse_order

    readable = readable.find_by_id *profile_ids unless profile_ids.empty?

    return readable

  end


  def user_readable(user)
    true
  end

  def user_editable(user)
    user.profile.staff_member?
  end


  def contact_links_string
    self.contact_links.values.join
  end


  def is_public(field)
    if self.privacy_settings
      if self.privacy_settings[field]=="true"
      then true
      else false
      end
    else false
    end
  end


  def email_screened
    if is_public("email")
    then  self.contact_links["email"]
    else ""
    end
  end


  def address_city_screened
    if is_public("address_city")
    then  address_city
    else ""
    end
  end

  def address_state_screened
    if is_public("address_state")
    then  address_state
    else ""
    end
  end

  def address_street_screened
    if is_public("address_street")
    then  address_street
    else ""
    end
  end

  def address_zip_screened
    if is_public("address_zip")
    then  address_zip
    else ""
    end
  end

  def company_name_screened
    if is_public("company_name")
    then  company_name
    else ""
    end
  end

  def company_website_screened
    if is_public("company_website")
    then  company_website
    else ""
    end
  end

  def job_description_screened
    if is_public("job_description")
    then  job_description
    else ""
    end
  end

  def job_title_screened
    if is_public("job_title")
    then  job_title
    else ""
    end
  end

  def name_first_screened
    if is_public("name_first")
    then  name_first
    else ""
    end
  end

  def name_last_screened
    if is_public("name_last")
    then  name_last
    else ""
    end
  end

  def name_middle_screened
    if is_public("name_middle")
    then  name_middle
    else ""
    end
  end

  def phone_home_screened
    if is_public("phone_home")
    then  phone_home
    else ""
    end
  end

  def phone_mobile_screened
    if is_public("phone_mobile")
    then  phone_mobile
    else ""
    end
  end

  def phone_work_screened
    if is_public("phone_work")
    then  phone_work
    else ""
    end
  end

  def profile_description_screened
    if is_public("profile_description")
    then  profile_description
    else ""
    end
  end

  def staffable?
    self.user.id != 127127
  end

end

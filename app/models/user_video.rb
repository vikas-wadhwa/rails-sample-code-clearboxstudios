class UserVideo < ActiveRecord::Base


  ################################################
  # class callbacks
  ################################################

  ################################################
  # Setup accessible (or protected) attributes for your model. Others available are:
  # attr_accessible :title, :body
  ################################################
  attr_accessible :video
  attr_accessible :image
  attr_accessible :video_type
  attr_accessible :title
  attr_accessible :description
  attr_accessible :credits
  attr_accessible :duration
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h


  #serialize :credits, ActiveRecord::Coders::Hstore

  validates_presence_of :video_type, :title, :description, :duration
  validates_numericality_of :duration, :greater_than => 0

  ################################################
  # setup relationships
  ################################################
  belongs_to :user
  has_many :user_credits, :dependent => :destroy
  accepts_nested_attributes_for :user_credits,
                                :allow_destroy => true,
                                :reject_if => proc { |record| record["user_id"].blank? || record["credit_id"].blank? }
  attr_accessible :user_credits_attributes
  has_many :credits, :through => :user_credits

  ################################################
  # setup Paperclip Image settings
  ################################################
  has_attached_file :image,
                    :s3_host_alias => User.cdn_bucket,
                    :bucket => User.media_bucket,
                    :url => ":s3_alias_url",
                    :path => ":user_id/videos/:id/photos/:style/:filename",
                    :styles => {
                        :fullsize => {:processors => [:thumbnail], :format => "jpg", :geometry => "100%"},
                        :large => {:processors => [:jcropper, :thumbnail], :format => "jpg", :geometry => "880x495#"},
                        :medium => {:processors => [:jcropper, :thumbnail], :format => "jpg", :geometry => "320x180#"},
                        :small => { :processors => [:jcropper, :thumbnail], :format => "jpg", :geometry => "112x63#"},
                        :tiny => {:processors => [:jcropper, :thumbnail], :format => "jpg", :geometry => "48x27#"}
                    },

                    :convert_options => {
                        :fullsize => "-quality 40 -interlace Plane -strip",
                        :large => "-quality 50 -interlace Plane -strip",
                        :medium => "-quality 50 -interlace Plane -strip",
                        :small => "-quality 50 -interlace Plane -strip",
                        :tiny => "-quality 80 -interlace Plane -strip"
                    },

                    :s3_headers => {"Cache-Control" => "max-age=315576000", "Expires" => 10.years.from_now.httpdate},

                    :default_url => Profile::PLACEHOLDER_VIDEO_IMAGE_URL

  validates_attachment_content_type :image,
                                    :content_type => ["image/jpeg", "image/gif",
                                                      "image/png", "image/pjpeg", "image/x-png",
                                                      "image/tif", "image/tiff", "image/bmp"
                                    ],
                                    :message => "must be a valid image"

  before_image_post_process :rename_attachment

  ################################################
  # setup Paperclip Video settings
  ################################################

  has_attached_file :video,
                    :s3_host_alias => User.cdn_bucket,
                    :bucket => User.media_bucket,
                    :url => ":s3_alias_url",
                    :path => ":user_id/videos/:id/:filename",
                    :s3_headers => {"Cache-Control" => "max-age=315576000", "Expires" => 10.years.from_now.httpdate},
                    :default_url => ""


  ################################################
  # Postgres searching
  ################################################
  include PgSearch
  multisearchable :against => [:video_type, :title, :description, :credits]


  ################################################
  # define enumerated column arrays
  ################################################
  ENUMERATIONS = {
      video_type: ["Demo Reel", "Feature Film ", "Short Film", "Television", "Web-isode", "Other"],
  }

  ################################################
  # setup scopes and accessors
  ################################################
  def set_defaults

    unless self.credits.present?
      Credit.default_credits.each do |item|
        @credit = self.user_credits.new
        @credit.credit_id = item.id
      end
    end

    self.video_type ||= ENUMERATIONS[:video_type].first
    self.title = "Untitled"
    self.description = "This video needs a description"
    self.duration = 60
  end

  def uploader
    self.user.profile
  end

  ################################################
  # setup controller url locations
  ################################################
  BASE_ROUTING_PATH = "/user/videos/"
  [:create, :attach_video, :attach_image, :crop, :destroy].each do |action|
    (CRUD_ROUTING_PATHS ||= {})[action] = "#{BASE_ROUTING_PATH}#{action}"
  end

  def edit_routing_path
    "#{BASE_ROUTING_PATH}#{self.id}"
  end

  def videos_path
    "#{self.user.id}/videos/#{self.id}"
  end

  ################################################
  # setup AWS filesystem bucket methods
  ################################################
  MEDIA_NAME = "user"
  include FileSystemPaths

  ################################################
  # Common attributes to photos
  ################################################
  include PhotoAttachmentAttributes

  ################################################
  # Common attributes to videos
  ################################################
  include VideoAttachmentAttributes


end

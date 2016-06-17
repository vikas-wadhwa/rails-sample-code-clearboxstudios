class UserPhoto < ActiveRecord::Base

  ################################################
  # Setup accessible (or protected) attributes for your model. Others available are:
  # attr_accessible :title, :body
  ################################################
  attr_accessible :image
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  ################################################
  # setup relationships
  ################################################
  belongs_to :user

  ################################################
  # setup Paperclip settings
  ################################################
  has_attached_file :image,
                    :s3_host_alias => User.cdn_bucket,
                    :bucket => User.media_bucket,
                    :url => ":s3_alias_url",
                    :path => ":user_id/photos/:style/:filename",
                    :styles => {
                        :fullsize =>  { :processors => [:thumbnail], :format => "jpg", :geometry => "100%"},
                        :large => { :processors => [:jcropper, :thumbnail], :format => "jpg", :geometry => "1000x1000>"},
                        :medium => { :processors => [:jcropper, :thumbnail], :format => "jpg", :geometry => "400x400#"},
                        :tiny => { :processors => [:jcropper, :thumbnail], :format => "jpg", :geometry => "50x50#"}
                        #:large =>  { :processors => [:jcropper, :thumbnail], :format => "jpg", :geometry => "880x495#"},
                        #:medium => { :processors => [:jcropper, :thumbnail], :format => "jpg", :geometry => "320x180#"},
                        #:small => { :processors => [:jcropper, :thumbnail], :format => "jpg", :geometry => "112x63#"}

                    },

                    :convert_options => {
                        :fullsize => "-quality 75 -interlace Plane -strip",
                        :large => "-quality 75 -interlace Plane -strip",
                        :medium => "-quality 60 -interlace Plane -strip",
                        :tiny => "-quality 90 -interlace Plane -strip"
                    },

                    :s3_headers => { "Cache-Control" => "max-age=315576000", "Expires" => 10.years.from_now.httpdate },

                    :default_url => Profile::PLACEHOLDER_IMAGE_URL


  validates_attachment_content_type :image,
                                    :content_type => ["image/jpeg", "image/gif",
                                                      "image/png", "image/pjpeg", "image/x-png",
                                                      "image/tif", "image/tiff", "image/bmp"
                                    ],
                                    :message => "must be a valid image"

  before_image_post_process :rename_attachment



  ################################################
  # Class methods
  ################################################



  ################################################
  # setup controller url location constants
  ################################################
  BASE_ROUTING_PATH = "/user/photos/"
  [:create, :crop, :update, :destroy].each do |action|
    (CRUD_ROUTING_PATHS ||= {})[action] = "#{BASE_ROUTING_PATH}#{action}"
  end

  ################################################
  # setup scopes and accessors
  ################################################
  def caption
    self.user.profile.full_name
  end


  ################################################
  # Boolean questions
  ################################################
  def is_profile?
    self.image(:original) == self.user.profile.image_url(:original)
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

end

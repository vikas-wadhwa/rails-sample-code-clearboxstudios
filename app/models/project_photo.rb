class ProjectPhoto < ActiveRecord::Base


  ################################################
  # Setup accessible (or protected) attributes for your model. Others available are:
  # attr_accessible :title, :body
  ################################################
  attr_accessible :image, :captured_filename
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  ################################################
  # setup relationships
  ################################################
  belongs_to :project

  ################################################
  # setup Paperclip settings
  ################################################
  has_attached_file :image,
                    :s3_host_alias => Project.media_bucket,
                    :bucket => Project.media_bucket,
                    :url => ":s3_alias_url",
                    :path => ":project_id/photos/:style/:filename",
                    :s3_headers => { "Cache-Control" => "max-age=315576000", "Expires" => 10.years.from_now.httpdate },
                    #processors: [:bulk],
                    :styles => {
                        :large =>  { format: "jpg", geometry:  "1000x1000"},
                        :medium => { format: "jpg", geometry:  "300x300"}
                    },

                    :convert_options => {
                        :large => "-quality 75 -interlace Plane -strip",
                        :medium => "-quality 75 -interlace Plane -strip"
                    },

                    :default_url => Project::PLACEHOLDER_IMAGE_URL

  validates_attachment_content_type :image,
                                    :content_type => ["image/jpg", "image/jpeg", "image/gif",
                                                      "image/png", "image/pjpeg", "image/x-png",
                                                      "image/tif", "image/tiff", "image/bmp"],
                                    :message => "must be a valid image"

  before_image_post_process :rename_attachment
  #after_image_post_process -> { Paperclip::BulkQueue.process(attachment) }


  ################################################
  # setup routing url locations
  ################################################
  def routing_path
    "/projects/#{self.project.id.to_s}/photos/"
  end

  def s3_path
    "#{project.id.to_s}/photos/original/"
  end


  ################################################
  # setup scopes and accessors
  ################################################
  def caption
    self.project.title
  end

  ################################################
  # setup AWS filesystem bucket methods
  ################################################
  MEDIA_NAME = "project"
  include FileSystemPaths

  ################################################
  # Common attributes to photos
  ################################################
  include PhotoAttachmentAttributes

end

##################################################################################################
## This concern allows models to extend into responding to methods that request filesystem paths,
## chiefly among AWS S3 and the localhost.
##
## Convention here will be reflected by the paths on the actual services as much as possible.
## Ideally the individual model with take care of any customization above and beyond convention
##################################################################################################
################################################################################################
# This enumeration generates global variables referencing the AWS urls for various resources,
# such as projects and user photos/videos, using naming methods set as convention here.
#
# Constants generated should be like:
#   AWS_S3_PUBLIC_BUCKET = "public.clearboxstudios.com"
#   AWS_S3_PROJECTS_BUCKET = "projects.clearboxstudios.com"
#   AWS_S3_USERS_BUCKET = "users.clearboxstudios.com"
#   AWS_RTMP_USERS_BUCKET = "rtmp-users.clearboxstudios.com"
#   AWS_RTMP_PROJECTS_BUCKET = "rtmp-projects.clearboxstudios.com"
#   AWS_CDN_USERS_BUCKET = "cdn-users.clearboxstudios.com"
#   AWS_CDN_PROJECTS_BUCKET = "cdn-projects.clearboxstudios.com"
################################################################################################


module FileSystemPaths
  extend ActiveSupport::Concern

  def self.included(base)
    base.blank?
  end


  ################################################
  # setup AWS bucket methods
  ################################################
  module ClassMethods

    def media_bucket
      base = self

      if base.constants.include?(:MEDIA_NAME)
        media_folder_name = base::MEDIA_NAME
      else
        media_folder_name = base.name.downcase
      end
      "#{media_folder_name}s.#{AWS_ACCOUNT_HOSTNAME}"
    end

    def cdn_bucket
      "cdn-#{media_bucket}"
    end


    def rtmp_bucket
      "rtmp-#{media_bucket}"
    end

    def rtmp_path
      "rtmp://#{rtmp_bucket}/cfx/st"
    end

  end

  ################################################
  # setup file accessors, by type
  ################################################
  def aws_post_url
    "#{AWS_S3_ACCESS_URL}/#{self.class.media_bucket}"
  end

  def documents_path
    "#{self.id.to_s}/documents"
  end

  def videos_path
    "#{self.id.to_s}/videos"
  end

  def photos_path
    "#{self.id.to_s}/photos"
  end

  def image_id
    self.image_links["#{self.class.name.downcase}_image"]
  end

  def video_image_id
    self.image_links["demo_image"]
  end

  def bucket_objects(folder)
    AwsMethods.get_bucket_objects(self.media_bucket, self.id.to_s + '/' + folder)
  end


  private

  def rename_attachment

    ################################################################################
    ## randomizing the attachment causes orphan files on S3,
    ## so we loop through and delete the S3 records for
    ## each style prior to rename/save
    ################################################################################
    AwsMethods.delete_attachments(self.image) unless self.new_record?

    extension = File.extname(image_file_name).downcase
    self.image.instance_write :file_name, "#{SecureRandom.hex(16)}#{extension}"

  end


end

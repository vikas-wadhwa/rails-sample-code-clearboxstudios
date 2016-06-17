##################################################################################################
## This concern allows models to extend into responding to methods that request filesystem paths,
## chiefly among AWS S3 and the localhost.
##
################################################################################################


module PhotoAttachmentAttributes
  extend ActiveSupport::Concern

  ################################################
  # Boolean questions
  ################################################
  def do_crop?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end


  def download_url(style)
    self.image.s3_object(style).url_for(:read, secure: true, expires: 90.minutes, response_content_disposition: "attachment;").to_s
  end


end

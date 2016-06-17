##################################################################################################
## This concern allows models to extend into responding to methods that request filesystem paths,
## chiefly among AWS S3 and the localhost.
##
################################################################################################

module VideoAttachmentAttributes
  extend ActiveSupport::Concern

  ################################################
  # Playback URL methods
  ################################################
  def credits_search_url
    "/credits/autocomplete"
  end

  def users_search_url
    "/profiles/autocomplete"
  end

  def basename
    if self.video.exists?
      filename = self.video.original_filename
      filename.slice(0..(filename.rindex(".") - 1))
    end
  end

  def url(type, *source)

    model = self.class::MEDIA_NAME.capitalize.constantize
    rtmp_path = model.rtmp_bucket
    cdn_path = model.cdn_bucket

    url = "#{self.videos_path}/#{self.basename}"

    if type == :flash
      "mp4:" + url

    else
      if source == "rtmp"
        "http://#{rtmp_path}/#{url}.#{type.to_s}"
      else
        "http://#{cdn_path}/#{url}.#{type.to_s}"
      end
    end

  end





end

# Jcropper paperclip processor
#
# This processor very slightly changes the default thumbnail processor in order to work properly with Jcrop
# the jQuery cropper plugin.

module Paperclip

  # Handles thumbnailing images that are uploaded.
  class Jcropper < Thumbnail

    def transformation_command
      if crop_command
        crop_command + super.first.sub(/ -crop \S+/, '')
      else
        super
      end
    end


    def crop_command
      target = @attachment.instance
      if target.do_crop?
        crop_command = ' -crop "' + target.crop_w + 'x' + target.crop_h + '+' + target.crop_x + '+' + target.crop_y + '" '
      end
    end

end

end
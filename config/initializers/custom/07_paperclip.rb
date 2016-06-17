
###################################################
## Paperclip settings for AWS S3
##################################################
Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_credentials] = {:access_key_id => AWS_S3_ACCESSKEY_ID, :secret_access_key => AWS_S3_SECRET_KEY_ID}


Paperclip.interpolates :user_id do |attachment, style|
  attachment.instance.user_id
end


Paperclip.interpolates :project_id do |attachment, style|
  attachment.instance.project_id
end
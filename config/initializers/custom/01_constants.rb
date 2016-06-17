###################################################
## Environment-specific constants
###################################################
AWS_FILE_SYSTEM_PATHS = {
    S3: ["public","projects","users"],
    RTMP: ["users","projects"],
    CDN: ["users","projects"]
}

case ENV["RAILS_ENV"]
  when "development"
    AWS_SUBDOMAIN_SUFFIX = "-dev"

  when "production"
    AWS_SUBDOMAIN_SUFFIX = ""
end


###################################################
## Formatting
###################################################
Date::DATE_FORMATS[:default] = "%m-%d-%Y"
Time::DATE_FORMATS[:default] = "%m-%d-%Y %H:%M"

###################################################
## Corporate
###################################################

CORPORATE_EMAIL_INFO = "info@clearboxstudios.com"
CORPORATE_EMAIL_BILLING = "billing@clearboxstudios.com"
CORPORATE_EMAIL_ACCOUNTS = "accounts@clearboxstudios.com"
CORPORATE_PHONE_WORK = "(773) 270-0269"

WEBFONT_URL_01 = "http://cloud.webtype.com/css/ce7539b7-dd23-4f2d-88ed-c10d14cb4fbb.css"

CORPORATE_LOGINS = {
    facebook: {username: Rails.application.secrets.facebook_user, password: Rails.application.secrets.facebook_pass},
    twitter: {username: Rails.application.secrets.twitter_user, password: Rails.application.secrets.twitter_pass},
    linkedin: {username: Rails.application.secrets.linkedin_user, password: Rails.application.secrets.linkedin_pass},
    youtube: {username: Rails.application.secrets.youtube_user, password: Rails.application.secrets.youtube_pass},
    vimeo: {username: Rails.application.secrets.vimeo_user, password: Rails.application.secrets.vimeo_pass},
    gmail_webadmin: {username: Rails.application.secrets.gmail_webadmin_user, password: Rails.application.secrets.gmail_webadmin_pass},
    gmail_accounts: {username: Rails.application.secrets.gmail_accounts_user, password: Rails.application.secrets.gmail_accounts_pass},
    gmail_billing: {username: Rails.application.secrets.gmail_billing_user, password: Rails.application.secrets.gmail_billing_pass},
}

CONTACT_LINKS_LIST = ["email","facebook", "twitter","linkedin","vimeo","youtube", "IMDb"]
CORPORATE_SOCIAL = {
    facebook: {url: "http://www.facebook.com/clearboxstudios"},
    twitter: {url: "http://www.twitter.com/clearboxstudios"},
    linkedin: {url: "http://www.linkedin.com/company/clearbox-studios"},
    googleplus: {url: "https://plus.google.com/u/0/?cfem=1#117268828497574298013/posts"},
    vimeo: {url: "http://www.vimeo.com/clearboxstudios"},
    youtube: {url: "http://www.youtube.com/clearboxstudios"}
}

###################################################
##  AWS
###################################################
AWS_ACCOUNT_HOSTNAME = "clearboxstudios.com"
AWS_S3_ACCESS_URL  = "https://s3.amazonaws.com"
AWS_CDN_PUBLIC_URL = "http://cdn-public.#{AWS_ACCOUNT_HOSTNAME}"
AWS_S3_ACCESSKEY_ID = Rails.application.secrets.aws_s3_accesskey_id
AWS_S3_SECRET_KEY_ID = Rails.application.secrets.aws_s3_secret_key_id
AWS.config(
    access_key_id: AWS_S3_ACCESSKEY_ID,
    secret_access_key: AWS_S3_SECRET_KEY_ID
)


###################################################
##  Segment IO
###################################################
SEGMENT_IO_KEY = Rails.application.secrets.segment_io_key

######################################################
## need this line for pg_search to work!!!!
######################################################
Paperclip.options[:command_path] = Rails.application.secrets.image_magick_path
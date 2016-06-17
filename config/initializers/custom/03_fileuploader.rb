###################################################
## AWS S3 direct upload
###################################################

S3DirectUpload.config do |c|
  c.access_key_id = AWS_S3_ACCESSKEY_ID       # your access key id
  c.secret_access_key = AWS_S3_SECRET_KEY_ID   # your secret access key
end
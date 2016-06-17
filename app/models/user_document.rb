class UserDocument < ActiveRecord::Base


  ################################################
  # Setup accessible (or protected) attributes for your model. Others available are:
  # attr_accessible :title, :body
  ################################################
  
  attr_accessible :document
  attr_accessible :thumbnail


  ################################################
  # setup relationships
  ################################################
  belongs_to :user
  

  ################################################
  # setup Paperclip settings
  ################################################

  has_attached_file :document, 
    :storage => :s3,
    :bucket => AWS_S3_USERS_BUCKET,
    :s3_credentials => {
      :access_key_id => AWS_S3_ACCESSKEY_ID,
      :secret_access_key => AWS_S3_SECRET_KEY_ID
    }, 
    :default_url => PLACEHOLDER_PROJECT_IMAGE_URL
    
    
end

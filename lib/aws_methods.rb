module AwsMethods


  ################################################
  # get s3 bucket items
  ################################################
  
  def self.get_bucket_objects(bucket_name, prefix)
 
    # Create the basic S3 object
    s3 = AWS::S3.new

    # Load up the 'bucket' we want to store things in
    bucket = s3.buckets[bucket_name]

    # Grab a reference to an object in the bucket with the name we require
    objects = bucket.objects.with_prefix(prefix).select { |obj| !(obj.key =~ /\/$/) }
  
  end


  def self.get_object (bucket, key)

    # Create the basic S3 object
    s3 = AWS::S3.new
    obj = s3.buckets[bucket].objects[key]

  end


  def self.delete_attachments(attachment)
  ## delete the styles
  attachment.styles.keys.each do |style|
      photo = AwsMethods.get_object(attachment.bucket_name, attachment.path(style))
      photo.delete
  end


  ## delete the original file
  attachment.s3_object.delete

  end



end
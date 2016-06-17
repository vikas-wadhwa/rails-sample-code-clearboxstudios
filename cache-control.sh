photos = [
        'DSC_0004.jpg',
        'DSC_0022.jpg',
        'DSC_0056.jpg',
        'DSC_0062.jpg',
        'DSC_0070.jpg',
        'DSC_0082.jpg',
        'DSC_0100.jpg',
        'DSC_0107.jpg',
        'DSC_0116.jpg',
        'DSC_0137.jpg',
        'DSC_0153.jpg',
        'DSC_0184.jpg',
        'DSC_0197.jpg',
        'DSC_0249.jpg',
        'DSC_0260.jpg',
        'DSC_0284.jpg',
        'DSC_0285.jpg',
        'DSC_0286.jpg',
        'DSC_0317.jpg',
        'DSC_0318.jpg'
]

photos.each do |photo|
    begin
      s3_object = AWS::S3::S3Object.find(photo.full_filename,
        'your_bucket_name')
      s3_object.cache_control = 'max-age=315360000'
      s3_object.save({:access => :public_read})
    rescue Exception => e
      logger.error("Unable to update photo with key " +
        "#{photo.full_filename}: #{e}")
    end
  end
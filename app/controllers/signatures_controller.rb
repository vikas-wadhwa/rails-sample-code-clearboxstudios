class SignaturesController < ApplicationController

require 'base64'
require 'openssl'
require 'digest/sha1'

  ################################################
  # return AWS signed urls
  ################################################
  def aws_uploads
          render json: {
            policy: aws_s3_upload_policy_document,
            signature: aws_s3_upload_signature,
            key: params[:doc][:directory] + "/" + params[:doc][:filename],
            success_action_redirect: "/"
          }
  end



  
  private

  ################################################
  # generate the policy document that amazon is expecting.
  ################################################
  def aws_s3_upload_policy_document
    Base64.encode64(
      {
        expiration: 2.days.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z'),
        conditions: [
          { bucket: params[:doc][:bucket]},
          { acl: 'public-read' },
          ["starts-with", "$key", params[:doc][:directory] + "/"],
          ["starts-with", "$success_action_status", "201"],
          ["starts-with", "$Content-Type", ""],
          ["starts-with", "$name", ""],
          ["starts-with", "$filename", ""],
          ["content-length-range", 0, 5368709120]
        ]
      }.to_json
    ).gsub(/\n|\r/, '')
  end

  ################################################
  # sign our request by Base64 encoding the policy document.
  ################################################
  def aws_s3_upload_signature
    Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new('sha1'),
        AWS_S3_SECRET_KEY_ID,
        aws_s3_upload_policy_document
      )
    ).gsub(/\n/, '')
  end
  
end
class SubmissionFilesController < ApplicationController
  def index 
    s3 = AWS::S3.new
    bucket = s3.buckets["gradecraft-#{Rails.env}"]
    return bucket.objects[params[:path]].url_for(:read, :expires => 15* 60).to_s #15 minutes
  end

  private

  def s3_policy_doc
    Base64.encode64(
      {
        expiration: 10.minutes.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z'),
        conditions: [
          { bucket: ENV['S3_BUCKET'] },
          { acl: 'private' },
          ["starts-with", "$key", "uploads/"],
          { success_action_status: '201' }
        ]
      }.to_json
    ).gsub(/\n|\r/, '')
  end

  def s3_signature
    Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new('sha1'),
        ENV['AWS_SECRET_KEY_ID'],
        s3_policy_doc
      )
    ).gsub(/\n/, '')
  end
end

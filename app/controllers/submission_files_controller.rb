class SubmissionFilesController < ApplicationController
  def signed_url
    s3 = AWS::S3.new
    bucket = s3.buckets["gradecraft-#{Rails.env}"]
    signed_data = bucket.presigned_post(key: "uploads/#{SecureRandom.uuid}/#{params[:title]}")
    render json: signed_data.fields
=begin
    render :json => {
      policy: s3_policy_doc,
      signature: s3_signature,
      key: "uploads/#{SecureRandom.uuid}/#{params[:doc][:title]}",
      success_action_redirect: "/"
    }
=end
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

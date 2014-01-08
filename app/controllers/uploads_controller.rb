class UploadsController < ApplicationController
  def remove
    upload = params[:model].classify.constantize.find params[:upload_id]
    s3 = AWS::S3.new
    bucket = s3.buckets["gradecraft-#{Rails.env}"]
    bucket.objects[CGI::unescape(upload.filepath)].delete
    upload.destroy

    redirect_to :back
  end
end

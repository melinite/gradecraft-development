class UploadsController < ApplicationController
  def remove
    puts params
    upload = controller_name.classify.constantize.find params.values.last
    puts upload
    s3 = AWS::S3.new
    bucket = s3.buckets["gradecraft-#{Rails.env}"]
    bucket.objects[CGI::unescape(upload.filepath)].delete
    upload.delete

    redirect_to :controller => params[:redirect][:controller], :action => "show", :id => params[:redirect][:id]
  end
end

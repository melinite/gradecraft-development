class SubmissionFile < ActiveRecord::Base

  attr_accessible :filename, :submission_id

  belongs_to :submission
  before_save :strip_path

  def url
    s3 = AWS::S3.new
    bucket = s3.buckets["gradecraft-#{Rails.env}"]
    return bucket.objects["uploads/submission_file/filename/#{id}/#{CGI::unescape(filename)}"].url_for(:read, :expires => 15* 60) #15 minutes
  end

  private

  def strip_path
    if filename.include? "gradecraft"
      filename.slice! "/gradecraft-#{Rails.env}/"
    end
    write_attribute(:filename, filename)
  end

end

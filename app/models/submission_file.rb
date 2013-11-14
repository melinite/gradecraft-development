class SubmissionFile < ActiveRecord::Base

  attr_accessible :filename, :submission_id

  belongs_to :submission
  before_save :strip_path

  def url
    s3 = AWS::S3.new
    bucket = s3.buckets["gradecraft-#{Rails.env}"]
    return bucket.objects[CGI::unescape(s3_filename)].url_for(:read, :expires => 15* 60).to_s #15 minutes
  end

  def s3_filename
    if filename =~ /submission_file/
      filename
    else
      "uploads/submission_file/filename/#{id}/#{filename}"
    end
  end

  private

  def strip_path
    if filename.include? "gradecraft"
      filename.slice! "/gradecraft-#{Rails.env}/"
    end
    write_attribute(:filename, filename)
  end

end

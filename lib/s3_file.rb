module S3File

  def url
    s3 = AWS::S3.new
    bucket = s3.buckets["gradecraft-#{Rails.env}"]
    return bucket.objects[CGI::unescape(filepath || filename)].url_for(:read, :expires => 15 * 60).to_s #15 minutes
  end

  private

  def strip_path
    if filepath.include? "gradecraft"
      filepath.slice! "/gradecraft-#{Rails.env}/"
    end
    write_attribute(:filepath, filepath)
    while filepath.include? "%2F"
      filepath.slice!(filepath.index("%2F"))
    end
    write_attribute(:filename, filepath)
  end
end

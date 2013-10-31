module S3File

  def url
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    puts filename
    s3 = AWS::S3.new
    bucket = s3.buckets["gradecraft-#{Rails.env}"]
    return bucket.objects[CGI::unescape(filename)].url_for(:read, :expires => 15 * 60).to_s #15 minutes
  end

  private

  def strip_path
    if filename.include? "gradecraft"
      filename.slice! "/gradecraft-#{Rails.env}/"
    end
    write_attribute(:filename, filename)
  end
end

S3DirectUpload.config do |config|
  config.access_key_id = ENV['AWS_ACCESS_KEY_ID']
  config.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  config.bucket = "gradecraft-#{Rails.env}"
end

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['Key'],
    :aws_secret_access_key  => ENV['Secret']
  }
  config.fog_directory = "gradecraft.#{Rails.env}"
  config.fog_public = :false # Not sure
end

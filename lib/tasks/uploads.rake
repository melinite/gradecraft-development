require 'digest/md5'

namespace :transfer_to do
  task :s3 => :environment do
    service = AWS::S3.new(
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
    STDOUT.sync = true
    Dir.glob('public/uploads/**/*').each do |f|
      if File.file?(f)
        remote_file = f.gsub('public/', '')
        obj = service.buckets["gradecraft.#{Rails.env}"].objects[remote_file] || nil

        if !obj
          service.buckets["gradecraft.#{Rails.env}"].objects.create(remote_file, f)
        elsif (obj.etag != Digest::MD5.hexdigest(File.read(f)))
          service.buckets["gradecraft.#{Rails.env}"].objects[remote_file].write(Pathname.new(f))
        end
      end
    end
    STDOUT.sync = false
  end
end

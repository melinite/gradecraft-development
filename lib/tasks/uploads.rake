namespace :transfer_to do
  task :s3 => :environment do
    system "duplicity #{Rails.root}/public/uploads s3+http://gradecraft/#{ENV['HOSTNAME']}/uploads"
  end
end

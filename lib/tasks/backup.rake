namespace :backup do
  task :db => :environment do
    database_config = Rails.configuration.database_configuration[Rails.env]
    filename = "#{database_config['database']}_#{Time.now.utc.strftime('%F')}.sql.gz"
    system "pg_dump -w -h localhost -p 5432 -U #{database_config['username']} #{database_config['database']} | gzip -c > db/backups/#{filename}"
    system "s3cmd put db/backups/#{filename} s3://gradecraft-#{Rails.env}/backups/db/#{filename}"
    puts "\nUploaded database dump to S3.\n\n"
  end
  task :files => :environment do
    system "duplicity /var/www s3+http://gradecraft/backups/#{ENV['BACKUP_BUCKET'] || 'unconfigured'}"
    puts "\nBacked up files to S3.\n\n"
  end
end

task :backup => 'backup:db'

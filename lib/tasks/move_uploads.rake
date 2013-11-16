namespace :transfer_to do
  task :new_paths => :environment do
    service = AWS::S3.new(
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
    bucket = service.buckets["gradecraft-#{Rails.env}"]
    bucket.objects.each do |obj|
      data = obj.metadata
      if obj.key.include? 'filename'
        if obj.key.include? 'assignment_file'
          obj.move_to('uploads/assignment_files/' + obj.metadata.name)
        end
        if obj.key.include? 'grade_file'
          obj.move_to('uploads/grade_files/' + obj.metadata.name)
        end
        if obj.key.include? 'submission_file'
          obj.move_to('uploads/submission_files/' + obj.metadata.name)
        end
        if obj.key.include? 'icon'
          obj.move_to('uploads/badge_icons/' + obj.metadata.name)
        end
      end
    end
  end
end

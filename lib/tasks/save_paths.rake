namespace :upload_paths do
  task :save => :environment do
    SubmissionFile.all.each do |sf|
      if sf.filepath.nil?
        sf.filepath = "uploads/submission_file/filename" + sf.id.to_s + "/" + sf.filename
        sf.save
      end
    end
    BadgeFile.all.each do |sf|
      if sf.filepath.nil?
        sf.filepath = "uploads/submission_file/filename" + sf.id.to_s + "/" + sf.filename
        sf.save
      end
    end
    GradeFile.all.each do |sf|
      if sf.filepath.nil?
        sf.filepath = "uploads/submission_file/filename" + sf.id.to_s + "/" + sf.filename
        sf.save
      end
    end
    AssignmentFile.all.each do |sf|
      if sf.filepath.nil?
        sf.filepath = "uploads/submission_file/filename" + sf.id.to_s + "/" + sf.filename
        sf.save
      end
    end
    ChallengeFile.all.each do |sf|
      if sf.filepath.nil?
        sf.filepath = "uploads/submission_file/filename" + sf.id.to_s + "/" + sf.filename
        sf.save
      end
    end
  end
end

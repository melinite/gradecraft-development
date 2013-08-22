class SubmissionFile < ActiveRecord::Base
  attr_accessible :filename, :submission_id

  belongs_to :submission

  mount_uploader :filename, SubmissionFileUploader
end

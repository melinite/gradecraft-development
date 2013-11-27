class SubmissionFile < ActiveRecord::Base
  include S3File

  attr_accessible :filename, :filepath, :submission_id

  belongs_to :submission
  before_save :strip_path
end

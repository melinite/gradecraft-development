class AssignmentFile < ActiveRecord::Base
  include S3File

  attr_accessible :filename, :filepath, :assignment_id

  belongs_to :assignment

  before_save :strip_path

end

class AssignmentFile < ActiveRecord::Base

  attr_accessible :filename, :assignment_id

  belongs_to :assignment

  mount_uploader :filename, AssignmentFileUploader

  private

end
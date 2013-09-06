class GradeFile < ActiveRecord::Base

  attr_accessible :filename, :grade_id

  belongs_to :grade

  mount_uploader :filename, GradeFileUploader

  private

end
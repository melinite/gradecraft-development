class GradeFile < ActiveRecord::Base
include S3File

  attr_accessible :filename, :filename, :grade_id

  belongs_to :grade

  before_save :strip_path

end

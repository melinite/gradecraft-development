class GradeFile < S3File
include S3File

  attr_accessible :filename, :grade_id

  belongs_to :grade

  before_save :strip_path

end

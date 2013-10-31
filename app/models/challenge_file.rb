class ChallengeFile < S3File

  attr_accessible :filename, :challenge_id

  belongs_to :challenge

  before_save :strip_path

end

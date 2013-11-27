class ChallengeFile < ActiveRecord::Base
  include S3File

  attr_accessible :filename, :filepath, :challenge_id

  belongs_to :challenge

  before_save :strip_path

end

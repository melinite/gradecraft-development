class ChallengeFile < ActiveRecord::Base

  attr_accessible :filename, :challenge_id

  belongs_to :challenge

  mount_uploader :filename, ChallengeFileUploader

  private

end
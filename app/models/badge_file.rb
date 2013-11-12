class BadgeFile < ActiveRecord::Base
  include S3File

  attr_accessible :filename, :badge_id

  belongs_to :assignment

  before_save :strip_path

end

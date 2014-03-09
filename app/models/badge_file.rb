class BadgeFile < ActiveRecord::Base
  include S3File

  attr_accessible :filename, :filepath, :badge_id

  belongs_to :badge

  before_save :strip_path

end

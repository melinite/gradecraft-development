class BadgeFile < ActiveRecord::Base

  attr_accessible :filename, :badge_id

  belongs_to :assignment

  mount_uploader :filename, BadgeFileUploader

  private

end
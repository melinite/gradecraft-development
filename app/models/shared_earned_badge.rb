class SharedEarnedBadge < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  mount_uploader :icon, SharedBadgeIconUploader
end

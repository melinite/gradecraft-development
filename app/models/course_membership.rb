class CourseMembership < ActiveRecord::Base
  belongs_to :course
  belongs_to :user

  attr_accessible :shared_badges, :auditing
end

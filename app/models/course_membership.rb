class CourseMembership < ActiveRecord::Base
  belongs_to :course
  belongs_to :user

  has_one :membership_calculation
  has_many :membership_scores

  attr_accessible :shared_badges, :auditing

end

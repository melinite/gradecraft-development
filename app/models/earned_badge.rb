class EarnedBadge < ActiveRecord::Base
  self.table_name = 'grades'

  default_scope -> { where(:type => 'EarnedBadge') }

  attr_accessible :badge, :student_id, :submission

  belongs_to :course
  belongs_to :badge, :foreign_key => :assignment_id
  belongs_to :student
  belongs_to :submission

  belongs_to :grade, :foreign_key => :parent_id

  before_validation :set_badge_and_course_and_student

  validates_presence_of :badge, :course, :student_id

  delegate :name, :description, :to => :badge

  private

  def set_badge_and_course_and_student
    self.assignment_id = submission.try(:assignment_id)
    self.assignment_type = submission.try(:assignment_type)
    self.student_id = submission.try(:student_id)
    self.course_id = badge.try(:course_id)
  end
end

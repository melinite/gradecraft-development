class EarnedBadge < ActiveRecord::Base
  self.table_name = 'grades'

  default_scope -> { where(:type => 'EarnedBadge') }

  attr_accessible :badge, :submission

  belongs_to :course
  belongs_to :badge, :foreign_key => :assignment_id
  belongs_to :student, :class_name => 'User'
  belongs_to :submission
  belongs_to :task
  belongs_to :grade, :foreign_key => :parent_id

  before_validation :set_badge_and_course_and_student_and_task

  validates_presence_of :badge, :course, :student, :task

  delegate :name, :description, :to => :badge

  private

  def set_badge_and_course_and_student_and_task
    self.task_id = submission.try(:task_id)
    self.student_id = submission.try(:student_id)
    self.assignment_id = submission.try(:assignment_id)
    self.course_id = submission.try(:course_id)
  end
end

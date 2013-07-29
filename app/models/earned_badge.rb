class EarnedBadge < ActiveRecord::Base
  self.table_name = 'grades'

  default_scope -> { where(:type => 'EarnedBadge') }

  attr_accessible :course, :course_id, :badge, :assignment_id, :submission,
    :submission_id, :student, :student_id, :task, :task_id

  belongs_to :course
  belongs_to :badge, :foreign_key => :assignment_id
  belongs_to :student, :class_name => 'User'
  belongs_to :submission # Optional
  belongs_to :task # Optional
  belongs_to :grade, :foreign_key => :parent_id # Optional

  before_validation :cache_associations

  validates_presence_of :badge, :course, :student

  delegate :name, :description, :to => :badge

  private

  def cache_associations
    self.student_id ||= submission.try(:student_id)
    self.task_id ||= submission.try(:task_id)
    self.assignment_id ||= submission.try(:assignment_id) || task.try(:assignment_id)
    self.course_id ||= badge.try(:course_id)
  end
end

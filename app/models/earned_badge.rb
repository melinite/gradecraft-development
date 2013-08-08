class EarnedBadge < ActiveRecord::Base
  attr_accessible :course, :course_id, :badge, :badge_id, :submission,
    :submission_id, :student, :student_id, :task, :task_id

  belongs_to :course
  belongs_to :badge
  belongs_to :student, :class_name => 'User'
  belongs_to :submission # Optional
  belongs_to :task # Optional
  belongs_to :grade # Optional
  belongs_to :group, :polymorphic => true # Optional

  before_validation :cache_associations

  validates_presence_of :badge, :course, :student

  delegate :name, :description, :to => :badge

  def self.score
    all.pluck('SUM(grades.score)').first || 0
  end

  private

  def cache_associations
    self.student_id ||= submission.try(:student_id)
    self.task_id ||= submission.try(:task_id)
    self.badge_id ||= submission.try(:assignment_id) || task.try(:assignment_id)
    self.course_id ||= badge.try(:course_id)
  end
end

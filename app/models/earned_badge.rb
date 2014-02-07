class EarnedBadge < ActiveRecord::Base
  attr_accessible :course, :badge, :submission, :student, :score, :feedback

  belongs_to :course
  belongs_to :badge
  belongs_to :student, :class_name => 'User', touch: true
  belongs_to :submission # Optional
  belongs_to :task # Optional
  belongs_to :grade # Optional
  belongs_to :group, :polymorphic => true # Optional

  before_validation :cache_associations

  validates_presence_of :badge, :course, :student

  delegate :name, :description, :icon, :to => :badge

  def self.score
    pluck('SUM(score)').first || 0
  end

  def self.scores_for_students
    group(:student_id).pluck('earned_badges.student_id, COALESCE(SUM(score), 0)')
  end

  private

  def cache_associations
    self.student_id ||= submission.try(:student_id)
    self.task_id ||= submission.try(:task_id)
    self.badge_id ||= submission.try(:assignment_id) || task.try(:assignment_id)
    self.course_id ||= badge.try(:course_id)
    self.score ||= badge.try(:point_total)
  end
end

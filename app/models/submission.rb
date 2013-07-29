class Submission < ActiveRecord::Base
  attr_accessible :task, :task_id, :assignment, :assignment_id, :assignment_type, :comment,
    :feedback, :group, :group_id, :attachment, :link, :student, :student_id,
    :creator, :creator_id, :text_feedback, :text_comment, :graded

  include Canable::Ables
  #userstamps! # adds creator and updater

  #has_attached_file :attachment

  belongs_to :task
  belongs_to :assignment, :polymorphic => true
  belongs_to :student, :class_name => 'User'
  belongs_to :creator, :class_name => 'User'
  belongs_to :group
  belongs_to :course

  has_one :grade, :dependent => :destroy
  accepts_nested_attributes_for :grade

  scope :ungraded, -> { where(graded: false) }

  before_validation :cache_associations

  validates_presence_of :student
  validates_uniqueness_of :task, :scope => :student, :allow_nil => true

  #Canable permissions
  def updatable_by?(user)
    if assignment.is_individual?
      submittable_id == user.id
    elsif assignment.has_teams?
      submittable_id == user.teams.first.id
    elsif assignment.has_groups?
      submittable_id == user.groups.first.id
    end
  end

  def destroyable_by?(user)
    if assignment.is_individual?
      submittable_id == user.id
    elsif assignment.has_teams?
      submittable_id == user.teams.first.id
    elsif assignment.has_groups?
      submittable_id == user.groups.first.id
    end
  end

  def viewable_by?(user)
    if assignment.is_individual?
      submittable_id == user.id
    elsif assignment.has_teams?
      submittable_id == user.teams.first.id
    elsif assignment.has_groups?
      submittable_id == user.groups.first.id
    end
  end

  #Grading status
  def status
    if grade
      "Graded"
    else
      "Ungraded"
    end
  end

  private

  def cache_associations
    self.assignment_id ||= task.try(:assignment_id)
    self.assignment_type ||= task.try(:assignment_type)
    self.course_id ||= assignment.try(:course_id)
  end
end

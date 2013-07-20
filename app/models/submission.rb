class Submission < ActiveRecord::Base
  attr_accessible :task, :task_id, :comment, :feedback, :group, :group_id,
    :attachment, :link, :student, :student_id, :creator, :creator_id,
    :text_feedback, :text_comment, :graded

  include Canable::Ables
  #userstamps! # adds creator and updater

  #has_attached_file :attachment

  belongs_to :task
  belongs_to :student, :class_name => 'User'
  belongs_to :creator, :class_name => 'User'
  belongs_to :group
  belongs_to :course

  has_one :grade
  accepts_nested_attributes_for :grade

  scope :ungraded, -> { where(graded: false) }

  before_validation :set_course_id

  validates_presence_of :task, :student

  delegate :assignment, :to => :task

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

  def set_course_id
    self.course_id = assignment.course_id
  end
end

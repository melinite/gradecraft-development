class Submission < ActiveRecord::Base
  attr_accessible :task, :task_id, :assignment, :assignment_id, :assignment_type, :comment,
    :feedback, :group, :group_id, :attachment, :link, :student, :student_id,
    :creator, :creator_id, :text_feedback, :text_comment, :graded, :submission_file, :submission_files_attributes

  include Canable::Ables

  belongs_to :task
  belongs_to :assignment, :polymorphic => true
  belongs_to :submission
  belongs_to :student, :class_name => 'User'
  belongs_to :creator, :class_name => 'User'
  belongs_to :group
  belongs_to :course

  before_save :clean_html

  has_one :grade, :dependent => :destroy
  accepts_nested_attributes_for :grade
  has_many :submission_files, :dependent => :destroy
  accepts_nested_attributes_for :submission_files

  scope :ungraded, -> { where(graded: false) }

  before_validation :cache_associations

  validates_presence_of :student
  validates_uniqueness_of :task, :scope => :student, :allow_nil => true

  #Canable permissions
  def updatable_by?(user)
    if assignment.is_individual?
      student_id == user.id
    elsif assignment.has_teams?
      student_id == user.teams.first.id
    elsif assignment.has_groups?
      student_id == user.groups.first.id
    end
  end

  def destroyable_by?(user)
    if assignment.is_individual?
      student_id == user.id
    elsif assignment.has_teams?
      submittable_id == user.teams.first.id
    elsif assignment.has_groups?
      submittable_id == user.groups.first.id
    end
  end

  def viewable_by?(user)
    if assignment.is_individual?
      student_id == user.id
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

  def name
    student.name
  end

  private

  def clean_html
    self.text_comment = Sanitize.clean(text_comment, Sanitize::Config::RESTRICTED)
  end

  def cache_associations
    self.assignment_id ||= task.try(:taskable_id)
    self.assignment_type ||= task.try(:assignment_type)
    self.course_id ||= assignment.try(:course_id)
  end
end

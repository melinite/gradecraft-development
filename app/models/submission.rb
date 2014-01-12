class Submission < ActiveRecord::Base
  attr_accessible :task, :task_id, :assignment, :assignment_id, :assignment_type_id, :comment,
    :feedback, :group, :group_id, :attachment, :link, :student, :student_id,
    :creator, :creator_id, :text_feedback, :text_comment, :graded, :submission_file, :submission_files_attributes,
    :course_id, :submission_file_ids

  include Canable::Ables

  belongs_to :task
  belongs_to :assignment, :polymorphic => true
  belongs_to :student, :class_name => 'User'
  belongs_to :creator, :class_name => 'User'
  belongs_to :group
  belongs_to :course

  before_save :clean_html

  has_one :grade, :dependent => :destroy
  accepts_nested_attributes_for :grade
  has_many :submission_files, :dependent => :destroy
  accepts_nested_attributes_for :submission_files

  scope :ungraded, -> { where('NOT EXISTS(SELECT 1 FROM grades WHERE submission_id = submissions.id OR ((assignment_id = submissions.assignment_id) AND (student_id = submissions.student_id)) AND (status = ?))', nil?) }
  scope :graded, -> { where('EXISTS(SELECT 1 FROM grades WHERE submission_id = submissions.id)') }

  before_validation :cache_associations

  #validates_presence_of :student, if: 'assignment.is_individual?'
  #validates_presence_of :group, if: 'assignment.has_groups?'
  validates_uniqueness_of :task, :scope => :student, :allow_nil => true
  validates_uniqueness_of :assignment_id, { :scope => :student_id }
  validates :link, :url => true, :allow_blank => true

  #Canable permissions#
  def updatable_by?(user)
    if assignment.is_individual?
      student_id == user.id
    elsif assignment.has_groups?
      group_id == user.group_for_assignment(assignment).id
    end
  end

  def destroyable_by?(user)
    if assignment.is_individual?
      student_id == user.id || user.is_staff?
    elsif assignment.has_groups?
      group_id == user.group_for_assignment(assignment).id
    end
  end

  def ungraded?
    ! grade.present? || grade.raw_score == nil?
  end

  def viewable_by?(user)
    if assignment.is_individual?
      student_id == user.id
    elsif assignment.has_groups?
      group_id == user.group_for_assignment(assignment).id
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
    if task
      self.assignment_id ||= task.assignment_id
      self.assignment_type ||= task.assignment_type
      self.course_id ||= task.assignment.course_id
    end
    self.assignment_id ||= assignment.id
    self.assignment_type ||= assignment.assignment_type
    self.course_id ||= assignment.course_id
  end
end

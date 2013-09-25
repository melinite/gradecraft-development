class Grade < ActiveRecord::Base
  include Canable::Ables

  attr_accessible :type, :raw_score, :final_score, :feedback, :assignment,
    :assignment_id, :badge_id, :created_at, :updated_at, :complete, :semis,
    :finals, :status, :attempted, :substantial, :student, :student_id,
    :badge_ids, :earned_badges_attributes, :earned, :submission,
    :submission_id, :badge_ids, :earned_badge_id, :earned_badges, :released,
    :earned_badges_attributes, :group, :group_id, :group_type, :task, :task_id,
    :graded_by_id, :team_id, :grade_file_ids, :grade_files_attributes, :grade_file

  STATUSES=%w(Graded Released)

  belongs_to :course
  belongs_to :assignment, touch: true
  belongs_to :assignment_type
  belongs_to :student, :class_name => 'User', touch: true
  belongs_to :team, touch: true
  belongs_to :submission # Optional
  belongs_to :task # Optional
  belongs_to :group, :polymorphic => true # Optional
  belongs_to :graded_by, class_name: 'User'

  has_many :earned_badges, :dependent => :destroy
  has_many :grade_criteria, :dependent => :destroy

  has_many :badges, :through => :earned_badges
  accepts_nested_attributes_for :earned_badges

  has_many :grade_scheme_elements, :through => :assignment

  before_validation :cache_associations
  before_save :cache_score_and_point_total

  has_many :grade_files, :dependent => :destroy
  accepts_nested_attributes_for :grade_files

  validates_presence_of :assignment, :assignment_type, :course, :student

  delegate :name, :description, :due_at, :assignment_type, :to => :assignment

  before_save :clean_html
  after_save :save_student
  after_destroy :save_student

  scope :completion, -> { where(order: "assignments.due_at ASC", :joins => :assignment) }
  scope :released, -> { joins(:assignment).where('status = ? OR NOT assignments.release_necessary', 'Released') }

  validates_numericality_of :raw_score, integer_only: true

  def self.score
    pluck('COALESCE(SUM(grades.score), 0)').first
  end

  def self.assignment_scores
    pluck('grades.assignment_id, grades.score')
  end

  def self.assignment_type_scores
    group('grades.assignment_type_id').pluck('grades.assignment_type_id, COALESCE(SUM(grades.score), 0)')
  end

  def score
    final_score || (raw_score * assignment_weight).round
  end

  def point_total
    assignment.point_total_for_student(student)
  end

  def assignment_weight
    assignment.weight_for_student(student)
  end

  def has_feedback?
    feedback != "" && feedback != nil
  end

  def is_released?
    status == 'Released'
  end

  #Canable Permissions
  def updatable_by?(user)
    creator == user
  end

  def creatable_by?(user)
    student_id == user.id
  end

  def viewable_by?(user)
    student_id == user.id
  end

  def self.to_csv(options = {})
    #CSV.generate(options) do |csv|
      #csv << ["First Name", "Last Name", "Score", "Grade"]
      #students.each do |user|
        #csv << [user.first_name, user.last_name]
        #, user.earned_grades(course), user.grade_level(course)]
      #end
    #end
  end

  private

  def clean_html
    self.feedback = Sanitize.clean(feedback, Sanitize::Config::RESTRICTED)
  end

  def save_student
    student.save
  end

  def cache_score_and_point_total
    self.score = score
    self.point_total = point_total
  end

  def cache_associations
    self.student_id ||= submission.try(:student_id)
    self.task_id ||= submission.try(:task_id)
    self.assignment_id ||= submission.try(:assignment_id) || task.try(:assignment_id)
    self.assignment_type_id ||= assignment.try(:assignment_type_id)
    self.course_id ||= assignment.try(:course_id)
    self.team_id ||= student.team_for_course(course).try(:id)
  end
end

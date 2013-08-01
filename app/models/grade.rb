class Grade < ActiveRecord::Base
  include Canable::Ables

  default_scope -> { where(:type => 'Grade') }

  attr_accessible :type, :raw_score, :final_score, :feedback, :assignment,
    :assignment_id, :badge_id, :created_at, :updated_at, :complete, :semis,
    :finals, :status, :attempted, :substantial, :student, :student_id,
    :badge_ids, :earned_badges_attributes, :earned, :submission,
    :submission_id, :badge_ids, :earned_badge_id, :earned_badges,
    :earned_badges_attributes, :group, :group_id, :group_type, :task, :task_id

  belongs_to :course
  belongs_to :assignment
  belongs_to :assignment_type
  belongs_to :student, :class_name => 'User'
  belongs_to :submission # Optional
  belongs_to :task # Optional
  belongs_to :group, :polymorphic => true # Optional

  has_many :earned_badges, :foreign_key => :parent_id, :dependent => :destroy

  has_many :badges, :through => :earned_badges
  accepts_nested_attributes_for :earned_badges

  has_many :grade_scheme_elements, :through => :assignment

  before_validation :cache_associations
  before_save :cache_score_and_point_total

  validates_presence_of :assignment, :assignment_type, :course

  delegate :name, :description, :due_date, :assignment_type, :to => :assignment

  after_save :save_student
  after_destroy :save_student

  scope :completion, -> { where(order: "assignments.due_date ASC", :joins => :assignment) }
  scope :released, -> { where(status: "Released") }

  def self.score
    all.pluck('SUM(score)').first || 0
  end

  def raw_score
    super || 0
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
    status == "Released"
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
  end
end

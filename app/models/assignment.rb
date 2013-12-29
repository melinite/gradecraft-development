class Assignment < ActiveRecord::Base
  attr_accessible :name, :description, :point_total, :due_at, :created_at,
    :updated_at, :level, :present, :grades_attributes, :assignment_type,
    :assignment_type_id, :grade_scope, :visible, :grade_scheme_id, :required,
    :open_time, :accepts_submissions, :student_logged_button_text,
    :student_logged, :release_necessary,
    :score_levels_attributes, :open_at, :close_time, :course,
    :assignment_rubrics_attributes, :rubrics_attributes, :media,
    :thumbnail, :media_credit, :caption, :media_caption, :accepts_submissions_until,
    :assignment_file_ids, :assignment_files_attributes, :assignment_file, :points_predictor_display,
    :assignment_score_levels_attributes, :assignment_score_level, :notify_released,
    :mass_grade_type

  self.inheritance_column = 'something_you_will_not_use'

  belongs_to :assignment_type, -> { order('order_placement ASC') }, touch: true
  accepts_nested_attributes_for :assignment_type

  has_many :weights, :class_name => 'AssignmentWeight'

  has_many :assignment_groups
  has_many :groups, :through => :assignment_groups

  has_many :tasks, :as => :assignment, :dependent => :destroy
  has_many :submissions, as: :assignment
  has_many :assignment_files
  has_many :grades, :dependent => :destroy
  accepts_nested_attributes_for :grades, :reject_if => Proc.new { |attrs| attrs[:raw_score].blank? }

  has_many :users, :through => :grades

  has_many :assignment_rubrics, dependent: :destroy
  accepts_nested_attributes_for :assignment_rubrics, allow_destroy: true
  has_many :rubrics, through: :assignment_rubrics, dependent: :destroy

  belongs_to :category
  belongs_to :course

  #For instances where the assignment inherits the score levels through the assignment type
  has_many :score_levels, :through => :assignment_type

  #for instances where the assignment needs it's own unique score levels
  has_many :assignment_score_levels
  accepts_nested_attributes_for :assignment_score_levels, allow_destroy: true

  delegate :mass_grade?, :student_weightable?, :to => :assignment_type

  before_validation :cache_associations, :cache_point_total
  after_save :save_grades, :save_weights

  has_many :assignment_files, :dependent => :destroy
  accepts_nested_attributes_for :assignment_files

  validates_presence_of :assignment_type, :course, :name, :grade_scope

  scope :individual_assignments, -> { where grade_scope: "Individual" }
  scope :group_assignments, -> { where grade_scope: "Group" }
  scope :team_assignments, -> { where grade_scope: "Team" }

  scope :chronological, -> { order('due_at ASC') }
  scope :alphabetical, -> { order('name ASC') }

  scope :visible, -> { where visible: TRUE }

  scope :with_due_date, -> { where('assignments.due_at IS NOT NULL') }
  scope :without_due_date, ->  { where('assignments.due_at IS NULL') }
  scope :future, -> { with_due_date.where('assignments.due_at >= ?', Time.now) }
  scope :still_accepted, -> { with_due_date.where('assignments.accepts_submissions_until >= ?', Time.now) }
  scope :past, -> { with_due_date.where('assignments.due_at < ?', Time.now) }

  scope :graded_for_student, ->(student) { where('EXISTS(SELECT 1 FROM grades WHERE assignment_id = assignments.id AND (status = ?) OR (status = ? AND NOT assignments.release_necessary) AND (assignments.due_at < NOW() OR student_id = ?))', 'Released', 'Graded', student.id) }
  scope :weighted_for_student, ->(student) { joins("LEFT OUTER JOIN assignment_weights ON assignments.id = assignment_weights.assignment_id AND assignment_weights.student_id = '#{sanitize student.id}'") }
scope :grading_done, -> { where 'grades.present? == 1' }

  amoeba do
    enable
    clone [ :tasks, :assignment_files ]
  end

  def start_time
    due_at
  end

  def to_json(options = {})
    super(options.merge(:only => [ :id, :content, :order, :done ] ))
  end

  def self.point_total
    pluck('COALESCE(SUM(assignments.point_total), 0)').first || 0
  end

  def self.assignment_type_point_totals_for_student(student)
    group('assignments.assignment_type_id').weighted_for_student(student).pluck('assignments.assignment_type_id, COALESCE(SUM(COALESCE(assignment_weights.point_total, assignments.point_total)), 0)')
  end

  def self.point_totals_for_student(student)
    weighted_for_student(student).pluck('assignments.id, COALESCE(assignment_weights.point_total, assignments.point_total)')
  end

  def self.point_total_for_student(student)
    weighted_for_student(student).pluck('SUM(COALESCE(assignment_weights.point_total, assignments.point_total))').first || 0
  end

  def self.with_assignment_weights_for_student(student)
    joins("LEFT OUTER JOIN assignment_weights ON assignments.id = assignment_weights.assignment_id AND assignment_weights.student_id = '#{sanitize student.id}'").select('assignments.*, COALESCE(assignment_weights.point_total, assignments.point_total) AS student_point_total')
  end

  def high_score
    grades.graded.joins('JOIN course_memberships on course_memberships.user_id = grades.student_id').where('course_memberships.auditing = false').maximum('grades.score')
  end

  def low_score
    grades.graded.joins('JOIN course_memberships on course_memberships.user_id = grades.student_id').where('course_memberships.auditing = false').minimum('grades.score')
  end

  def average
    grades.graded.joins('JOIN course_memberships on course_memberships.user_id = grades.student_id').where('course_memberships.auditing = false').average('grades.score').round(2) if grades.graded.present?
  end

  def submitted_average
    grades.graded.where("score > 0").average('score').round(2) if grades.graded.present?
  end

  def release_necessary?
    release_necessary == true
  end

  def is_individual?
    !['Group'].include? grade_scope
  end

  def has_groups?
    grade_scope=="Group"
  end

  #Currently we only have Assignments available to individuals and groups, but perhaps we should switch them to use assignments rather than challenges
  def has_teams?
    grade_scope=="Team"
  end

  def point_total
    super || assignment_type.universal_point_value || 0
  end

  def point_total_for_student(student, weight = nil)
    (point_total * weight_for_student(student, weight)).round
  end

  def weight_for_student(student, weight = nil)
    return 1 unless student_weightable?
    weight ||= (weights.where(student: student).pluck('weight').first || 0)
    weight > 0 ? weight : default_weight
  end

  def default_weight
    course.default_assignment_weight
  end

  def grade_for_student(student)
    grades.graded.where(student_id: student).first
  end

  #get a grade object for a student if it exists - graded or not. this is used in the import grade
  def all_grade_statuses_grade_for_student(student)
    grades.where(student_id: student).first
  end

  def score_for_student(student)
    grades.graded.where(student_id: student).pluck('score').first
  end

  def released_grade_for_student(student)
    grades.released.where(student: student).pluck('score').first
  end

  def past?
    due_at != nil && due_at < Date.today
  end

  def future?
    due_at != nil && due_at >= Date.today
  end

  def still_accepted?
    (accepts_submissions_until? && accepts_submissions_until >= Date.today) || (due_at? && due_at >= Date.today) || (due_at == nil && accepts_submissions_until == nil)
  end

  def soon?
    if due_at?
      Time.now <= due_at && due_at < (Time.now + 7.days)
    end
  end

  def fixed?
    points_predictor_display == "Fixed"
  end

  def has_ungraded_submissions?
    has_submissions == true && submissions.try(:ungraded)
  end

  def slider?
    points_predictor_display == "Slider"
  end

  def select?
    points_predictor_display == "Select List"
  end

  #We allow students to record certain boolean grades - thus far has been used to let them record attendance
  def self_gradeable?
    student_logged == true
  end

  #We allow instructors to mark if an assignment is 'required' - students must do the work to pass the class.
  def is_required?
    required == true
  end

  def has_levels?
   self.assignment_score_levels.present?
  end

  def grade_level(grade)
    score_levels.each do |score_level|
      return score_level.name if grade.raw_score == score_level.value
    end
    nil
  end

  #The below four are the Quick Grading Types, can be set at either the assignment or assignment type level
  def grade_checkboxes?
    assignment_type.mass_grade_type == "Checkbox" || self.mass_grade_type == "Checkbox"
  end

  def grade_select?
    assignment_type.mass_grade_type == "Select List" || self.mass_grade_type == "Select List"
  end

  def grade_radio?
    assignment_type.mass_grade_type == "Radio Buttons" || self.mass_grade_type == "Radio Buttons"
  end

  def grade_text?
    assignment_type.mass_grade_type == "Text" || self.mass_grade_type == "Text"
  end

  #Checking to see if the assignment is still open and accepting submissons
  def open?
    (open_at != nil && open_at < Time.now) && (due_at != nil && due_at > Time.now)
  end


  #Counting how many non-zero grades there are for an assignment
  def positive_grades
    grades.where("score > 0").count
  end

  #Calculating attendance rate, which tallies number of people who have positive grades for attendance divided by the total number of students in the class
  def attendance_rate(course)
   ((positive_grades / course.graded_student_count.to_f) * 100).round(2)
  end

  #gradebook
  def self.gradebook_for_course(course, options = {})
    CSV.generate(options) do |csv|
      csv << ["First Name", "Last Name", "Email", "Score", "Grade" ]
      course.students.each do |student|
        csv << [student.first_name, student.last_name, student.email, student.score_for_course(course)]
      end
    end
  end

  private

  def cache_point_total
    self.point_total = point_total
  end

  def cache_associations
    self.course_id ||= assignment_type.try(:course_id)
  end

  def save_grades
    grades.reload.each(&:save)
  end

  def save_weights
    weights.reload.each(&:save)
  end
end

class Assignment < ActiveRecord::Base
  attr_accessible :name, :description, :point_total, :open_at, :due_at, :grade_scope, :visible, :required, 
    :accepts_submissions, :student_logged_button_text, :student_logged, :release_necessary, :media,
    :thumbnail, :media_credit, :caption, :media_caption, :accepts_submissions_until, :points_predictor_display,
    :notify_released, :mass_grade_type, :include_in_timeline, :include_in_predictor, 
    :grades_attributes, :assignment_file_ids, :assignment_files_attributes, :assignment_file, 
    :assignment_score_levels_attributes, :assignment_score_level, :score_levels_attributes

  #self.inheritance_column = 'something_you_will_not_use'

  belongs_to :course

  belongs_to :assignment_type, -> { order('order_placement ASC') }
  delegate :mass_grade?, :student_weightable?, :to => :assignment_type

  #For instances where the assignment inherits the score levels through the assignment type
  has_many :score_levels, :through => :assignment_type

  #for instances where the assignment needs it's own unique score levels
  has_many :assignment_score_levels
  accepts_nested_attributes_for :assignment_score_levels, allow_destroy: true, :reject_if => proc { |a| a['value'].blank? || a['name'].blank? }
  
  has_many :weights, :class_name => 'AssignmentWeight'

  has_many :assignment_groups
  has_many :groups, :through => :assignment_groups

  has_many :tasks, :as => :assignment, :dependent => :destroy

  has_many :submissions, as: :assignment

  has_many :grades, :dependent => :destroy
  accepts_nested_attributes_for :grades, :reject_if => Proc.new { |attrs| attrs[:raw_score].blank? }

  has_many :users, :through => :grades

  has_many :assignment_rubrics, dependent: :destroy
  accepts_nested_attributes_for :assignment_rubrics, allow_destroy: true
  has_many :rubrics, through: :assignment_rubrics, dependent: :destroy
  
  has_many :assignment_files, :dependent => :destroy
  accepts_nested_attributes_for :assignment_files

  before_save :clean_html
  before_validation :cache_associations, :cache_point_total
  after_save :save_grades, :save_weights


  validates_presence_of :name

  # Filtering Assignments by Team Work, Group Work, and Individual Work
  scope :individual_assignments, -> { where grade_scope: "Individual" }
  scope :group_assignments, -> { where grade_scope: "Group" }
  scope :team_assignments, -> { where grade_scope: "Team" }

  # Filtering Assignments by where in the interface they are displayed
  scope :timelineable, -> { where(:include_in_timeline => true) }
  scope :predictable, -> { where(:include_in_predictor => true) }

  # Invisible Assignments are displayed on the instructor side, but not students (until they have a grade for them)
  scope :visible, -> { where visible: TRUE }

  # Sorting assignments by different properties
  scope :chronological, -> { order('due_at ASC') }
  scope :alphabetical, -> { order('name ASC') }

  # Filtering Assignments by various date properties
  scope :with_due_date, -> { where('assignments.due_at IS NOT NULL') }
  scope :without_due_date, ->  { where('assignments.due_at IS NULL') }
  scope :future, -> { with_due_date.where('assignments.due_at >= ?', Time.now) }
  scope :still_accepted, -> { with_due_date.where('assignments.accepts_submissions_until >= ?', Time.now) }
  scope :past, -> { with_due_date.where('assignments.due_at < ?', Time.now) }

  # Assignments and Grading
  scope :graded_for_student, ->(student) { where('EXISTS(SELECT 1 FROM grades WHERE assignment_id = assignments.id AND (status = ?) OR (status = ? AND NOT assignments.release_necessary) AND (assignments.due_at < NOW() OR student_id = ?))', 'Released', 'Graded', student.id) }
  scope :weighted_for_student, ->(student) { joins("LEFT OUTER JOIN assignment_weights ON assignments.id = assignment_weights.assignment_id AND assignment_weights.student_id = '#{sanitize student.id}'") }

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
    if grades.graded.present?
      grades.graded.where("score > 0").average('score').round(2) 
    else
      0
    end
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
    due_at != nil && due_at < Time.now
  end

  def future?
    due_at != nil && due_at >= Time.now
  end

  def still_accepted?
    (accepts_submissions_until.present? && accepts_submissions_until >= Time.now) || (due_at.present? && due_at >= Time.now ) || (due_at == nil && accepts_submissions_until == nil)
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

  #Calculates attendance rate as an integer.
   def attendance_rate_int(course)
   ((positive_grades / course.graded_student_count.to_f) * 100).to_i
  end

  #gradebook
  def self.gradebook_for_course(course, options = {})
    CSV.generate(options) do |csv|
      csv << ["First Name", "Last Name", "Email", "Score", "Grade", "Statement", "Feedback" ]
      course.students.each do |student|
        csv << [student.first_name, student.last_name, student.email, student.score_for_course(course)]
      end
    end
  end

  #single assignment gradebook
  def gradebook_for_assignment(assignment, options = {})
    CSV.generate(options) do |csv|
      csv << ["First Name", "Last Name", "Email", "Score", "Statement", "Feedback" ]
      course.students.each do |student|
        csv << [student.first_name, student.last_name, student.email, student.grade_for_assignment(assignment).score, student.submission_for_assignment(assignment).try(:text_comment), student.grade_for_assignment(assignment).try(:feedback) ]
      end
    end
  end

  private

  def clean_html
    self.description = Sanitize.clean(description, Sanitize::Config::BASIC)
  end

  def cache_point_total
    self.point_total = point_total
  end

  def cache_associations
    self.course_id ||= assignment_type.try(:course_id)
  end

  # Checking to see if the assignment point total has altered, and if it has resaving grades
  def save_grades
    if self.point_total_changed?
      grades.reload.each(&:save)
    end
  end

  # Checking to see if the assignment point total has altered, and if it has resaving weights
  def save_weights
    if self.point_total_changed?
      weights.reload.each(&:save)
    end
  end
end

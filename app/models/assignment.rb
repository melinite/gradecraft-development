class Assignment < ActiveRecord::Base
  self.inheritance_column = 'something_you_will_not_use'

  belongs_to :grade_scheme
  has_many :grade_scheme_elements, :through => :grade_scheme

  belongs_to :assignment_type
  accepts_nested_attributes_for :assignment_type

  has_many :weights, :class_name => 'AssignmentWeight'
  has_many :assignment_groups
  has_many :groups, :through => :assignment_groups

  has_many :tasks, :as => :taskable, :dependent => :destroy
  has_many :submissions
  has_many :assignment_files
  has_many :grades
  accepts_nested_attributes_for :grades

  has_many :users, :through => :grades

  has_many :assignment_rubrics, dependent: :destroy
  accepts_nested_attributes_for :assignment_rubrics, allow_destroy: true
  has_many :rubrics, through: :assignment_rubrics, dependent: :destroy

  belongs_to :category
  belongs_to :course

  has_many :score_levels, :through => :assignment_type
  accepts_nested_attributes_for :score_levels, allow_destroy: true

  delegate :points_predictor_display, :mass_grade?, :student_weightable?, :to => :assignment_type

  before_validation :cache_associations, :cache_point_total
  after_save :save_grades, :save_weights

  has_many :assignment_files, :dependent => :destroy
  accepts_nested_attributes_for :assignment_files

  validates_presence_of :assignment_type, :course, :name, :grade_scope

  attr_accessible :name, :description, :point_total, :due_at, :created_at,
    :updated_at, :level, :present, :grades_attributes, :assignment_type,
    :assignment_type_id, :grade_scope, :visible, :grade_scheme_id, :required,
    :open_time, :accepts_submissions, :student_logged_button_text,
    :student_logged, :badge_set_id, :release_necessary,
    :score_levels_attributes, :open_at, :close_time, :course,
    :assignment_rubrics_attributes, :rubrics_attributes, :media,
    :thumbnail, :media_credit, :caption, :media_caption, :accepts_submissions_until,
    :assignment_file_ids, :assignment_files_attributes, :assignment_file

  scope :individual_assignments, -> { where grade_scope: "Individual" }
  scope :group_assignments, -> { where grade_scope: "Group" }
  scope :team_assignments, -> { where grade_scope: "Team" }

  scope :chronological, -> { order('due_at ASC') }

  scope :with_due_date, -> { where('assignments.due_at IS NOT NULL') }
  scope :without_due_date, ->  { where('assignments.due_at IS NULL') }
  scope :future, -> { with_due_date.where('assignments.due_at >= ?', Time.now) }
  scope :still_accepted, -> { with_due_date.where('assignments.accept_submissions_until >= ?', Time.now) }
  scope :past, -> { with_due_date.where('assignments.due_at < ?', Time.now) }
  scope :graded_for_student, ->(student) { where('EXISTS(SELECT 1 FROM grades WHERE assignment_id = assignments.id AND (status = ? OR NOT assignments.release_necessary) AND (assignments.due_at < NOW() OR student_id = ?))', 'Released', student.id) }

  scope :grading_done, -> { where 'grades.present? == 1' }

  def start_time
    due_at
  end

  def self.point_total
    pluck('SUM(assignments.point_total)').first || 0
  end

  def self.point_total_for_student(student)
    joins("LEFT OUTER JOIN assignment_weights ON assignments.id = assignment_weights.assignment_id AND assignment_weights.student_id = '#{student.id}'").pluck('SUM(COALESCE(assignment_weights.point_total, assignments.point_total))').first || 0
  end

  def high_score
    grades.maximum('score')
  end

  def low_score
    grades.minimum('score')
  end

  def average
    grades.average('score')
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

  def point_total
    super || assignment_type.universal_point_value
  end

  def point_total_for_student(student, weight = nil)
    (point_total * weight_for_student(student, weight)).round
  end

  def weight_for_student(student, weight = nil)
    return 1 unless student_weightable?
    weight ||= (weights.where(student_id: student).pluck('weight').first || 0)
    weight > 0 ? weight : course.default_assignment_weight
  end

  def grade_for_student(student)
    grades.where(student: student).pluck('score').first
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
    accepts_submissions_until != nil && accepts_submissions_until >= Date.today
  end

  def soon?
    if due_at?
      Time.now <= due_at && due_at < (Time.now + 7.days)
    end
  end

  def fixed?
    points_predictor == "Fixed"
  end

  def has_ungraded_submissions?
    has_submissions == true && submissions.try(:ungraded)
  end

  def slider?
    points_predictor == "Slider"
  end

  def select?
    points_predictor == "Select List"
  end

  def self_gradeable?
    student_logged == true
  end

  def is_required?
    required == true
  end

  def has_levels?
    assignment_type.levels == true
  end

  def grade_checkboxes?
    assignment_type.mass_grade_type == "Checkbox"
  end

  def grade_select?
    assignment_type.mass_grade_type == "Select List"
  end

  def grade_radio?
    assignment_type.mass_grade_type == "Radio Buttons"
  end

  def grade_text?
    assignment_type.mass_grade_type == "Text"
  end

  def open?
    (open_at != nil && open_at < Time.now) && (due_at != nil && due_at > Time.now)
  end

  def grade_level(grade)
    score_levels.each do |score_level|
      return score_level.name if grade.raw_score == score_level.value
    end
    nil
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

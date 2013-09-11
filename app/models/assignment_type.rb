class AssignmentType < ActiveRecord::Base
  attr_accessible :due_date_present, :levels, :max_value, :name,
    :percentage_course, :point_setting, :points_predictor_display,
    :predictor_description, :resubmission, :universal_point_value, :course,
    :course_id, :order_placement, :student_weightable, :mass_grade,
    :score_levels_attributes, :score_level, :mass_grade_type, :course,
    :student_logged_revert_button_text, :student_logged_button_text

  belongs_to :course
  belongs_to :grade_scheme
  has_many :assignments
  has_many :submissions, :through => :assignments
  has_many :assignment_weights
  has_many :grades
  has_many :score_levels
  accepts_nested_attributes_for :score_levels, allow_destroy: true

  validates_presence_of :name, :points_predictor_display, :point_setting

  scope :student_weightable, -> { where(:student_weightable => true) }

  def slider?
    points_predictor_display == "Slider"
  end

  def fixed?
    points_predictor_display == "Fixed"
  end

  def select?
    points_predictor_display == "Select List"
  end

  def per_assignment?
    points_predictor_display == "Set per Assignment"
  end

  def has_levels?
    levels == true
  end

  def has_soon_assignments?
    assignments.any?(&:soon?)
  end

  def grade_checkboxes?
    mass_grade_type == "Checkbox"
  end

  def grade_select?
    mass_grade_type == "Select List"
  end

  def grade_radio?
    mass_grade_type == "Radio Buttons"
  end

  def grade_text?
    mass_grade_type == "Text"
  end

  def weight_for_student(student)
    return 1 unless student_weightable?
    assignment_weights.where(student: student).weight
  end
end

class Course < ActiveRecord::Base
  attr_accessible :badge_set_ids, :courseno, :name,
    :semester, :year, :badge_setting, :team_setting, :team_term, :user_term,
    :user_id, :course_id, :homepage_message, :group_setting,
    :total_assignment_weight, :assignment_weight_close_date, :team_roles,
    :section_leader_term, :group_term, :assignment_weight_type,
    :has_submissions, :teams_visible, :badge_use_scope,
    :weight_term, :badges_value, :predictor_setting, :max_group_size,
    :min_group_size, :shared_badges, :graph_display, :max_assignment_weight,
    :assignments, :default_assignment_weight, :grade_scheme_id, :accepts_submissions

  has_many :course_memberships
  has_many :users, :through => :course_memberships
  accepts_nested_attributes_for :users

  with_options :dependent => :destroy do |c|
    c.has_many :assignment_types
    c.has_many :assignments
    c.has_many :badge_sets
    c.has_many :badges
    c.has_many :categories
    c.has_many :challenges
    c.has_many :earned_badges
    c.has_many :grade_schemes
    c.has_many :grades
    c.has_many :groups
    c.has_many :group_memberships
    c.has_many :rubrics
    c.has_many :submissions
    c.has_many :teams
  end

  has_many :grade_scheme_elements, :through => :grade_schemes
  belongs_to :grade_scheme

  validates_presence_of :name, :badge_setting, :group_setting, :max_assignment_weight, :total_assignment_weight

  def user_term
     "Player" || super
  end

  def team_term
    "Team" || super
  end

  def group_term
     "Group" || super
  end

  def section_leader_term
    "Team Leader" || super
  end

  def weight_term
    "Multiplier" || super
  end

  def students
    users.students
  end

  def has_teams?
    team_setting == true
  end

  def graph_display?
    graph_display == true
  end

  def teams_visible?
    teams_visible == true
  end

  def has_badges?
    badge_setting == true
  end

  def valuable_badges?
    badges_value == true
  end

  def predictor_on?
    predictor_setting == true
  end

  def has_groups?
    group_setting == true
  end

  def course_badges?
    badge_use_scope == "Course"
  end

  def assignment_badges?
    badge_use_scope == "Assignment"
  end

  def multi_badges?
    badge_use_scope == "Both"
  end

  def shared_badges?
    shared_badges == true
  end

  def student_weighted?
    total_assignment_weight > 0
  end

  def team_roles?
    team_roles == true
  end

  def has_submissions?
    accepts_submissions == true
  end

  def grade_level_for_score(score)
    grade_scheme.try(:grade_level_for_course, score)
  end

  def membership_for_student(student)
    course_memberships.detect { |m| m.user_id == student.id }
  end

  def assignment_weight_for_student(student)
    student.assignment_weights.pluck('weight').sum
  end

  def assignment_weight_spent_for_student(student)
    assignment_weight_for_student(student) >= total_assignment_weight
  end

  def minimum_course_score
    #.min
  end

  def maximum_course_score
    #.max
  end

  def average_course_score
    #.max
  end

  def median_course_score
    #len % 2 == 1 ? sorted[len/2] : (sorted[len/2 - 1] + sorted[len/2]).to_f / 2
  end
end

class Course < ActiveRecord::Base
  attr_accessible :badge_set_ids, :courseno, :name,
    :semester, :year, :badge_setting, :team_setting, :team_term, :user_term,
    :user_id, :course_id, :homepage_message, :group_setting,
    :total_assignment_weight, :assignment_weight_close_date, :team_roles,
    :section_leader_term, :group_term, :assignment_weight_type,
    :has_submissions, :teams_visible, :badge_use_scope,
    :weight_term, :badges_value, :predictor_setting, :max_group_size,
    :min_group_size, :shared_badges, :graph_display, :max_assignment_weight,
    :assignments, :default_assignment_weight

  has_many :course_memberships
  has_many :users, :through => :course_memberships
  accepts_nested_attributes_for :users

  with_options :dependent => :destroy do
    has_many :assignment_types
    has_many :assignments
    has_many :badge_sets
    has_many :badges
    has_many :earned_badges
    has_many :grade_schemes
    has_many :grades
    has_many :groups
    has_many :submissions
    has_many :teams
  end

  has_many :grade_scheme_elements, :through => :grade_schemes
  has_many :team_assignments, :dependent => :destroy

  validates_presence_of :name, :badge_setting, :team_setting, :group_setting

  def user_term
    super || "Player"
  end

  def team_term
    super || "Team"
  end

  def group_term
    super || "Group"
  end

  def section_leader_term
    super || "Team Leader"
  end

  def weight_term
    super || "Multiplier"
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

  def membership_for_student(student)
    course_memberships.detect { |m| m.user_id == student.id }
  end

  def total_points(options = {})
    (options[:past] ? assignments.past : assignments).to_a.sum(&:point_total)
  end

  def running_total_points
    assignments.past.map { |assignment| assignment.point_total_for_student(student) }.sum
  end

  def badge_total
    badges.sum(:value)
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

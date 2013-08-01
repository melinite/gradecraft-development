class User < ActiveRecord::Base
  authenticates_with_sorcery!

  include Canable::Cans

  before_save :set_default_course
  after_save :cache_scores

  ROLES = %w(student professor gsi admin)

  ROLES.each do |role|
    scope role.pluralize, -> { where role: role }
  end

  attr_accessor :remember_me
  attr_accessible :username, :email, :crypted_password, :remember_me_token,
    :avatar_file_name, :role, :first_name, :last_name, :rank, :user_id,
    :display_name, :private_display, :default_course_id, :last_activity_at,
    :last_login_at, :last_logout_at, :team_ids, :courses, :course_ids,
    :shared_badges, :earned_badges, :earned_badges_attributes, :password, :password_confirmation

  scope :alpha, -> { where order: 'last_name ASC' }
  scope :order_by_high_score, -> { order 'course_memberships.score DESC' }
  scope :order_by_low_score, -> { order 'course_memberships.score ASC' }

  has_many :course_memberships
  has_many :courses, :through => :course_memberships
  accepts_nested_attributes_for :courses
  accepts_nested_attributes_for :course_memberships
  belongs_to :default_course, :class_name => 'Course'
  has_many :assignment_weights, :foreign_key => :student_id
  has_many :assignments, :through => :grades

  has_many :submissions, :foreign_key => :student_id, :dependent => :destroy
  has_many :created_submissions, :as => :creator
  has_many :grades, :foreign_key => :student_id, :dependent => :destroy

  has_many :earned_badges, :foreign_key => :student_id, :dependent => :destroy
  accepts_nested_attributes_for :earned_badges, :reject_if => proc { |attributes| attributes['earned'] != '1' }

  has_many :badges, :through => :earned_badges

  has_many :group_memberships
  with_options :through => :group_memberships, :source => :group do |u|
    u.has_many :teams, :source_type => 'Team'
    u.has_many :groups, :source_type => 'Group'
  end

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #validates_length_of :password, :minimum => 3, :message => "password must be at least 3 characters long", :if => :password
  #validates_confirmation_of :password, :message => "should match confirmation", :if => :password
  validates :username, :presence => true,
                    :length => { :maximum => 50 }
  validates :email, :presence => true,
                    :format   => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  def self.find_or_create_by_lti_auth_hash(auth_hash)
    criteria = { lti_uid: auth_hash['uid'] }
    where(criteria).first || create!(criteria) do |u|
      auth_hash['info'].tap do |info|
        u.username = info['ext_sakai_eid']
        u.email = info['email']
        u.first_name = info['first_name']
        u.last_name = info['last_name']
      end
      case auth_hash['roles']
      when 'instructor'
        u.role = 'professor'
      else
        u.role = 'student'
      end
    end
  end

  #Course
  def find_scoped_courses(course_id)
    if is_admin? || self.course_ids.include?(course_id)
      Course.find(course_id)
    else
      raise
    end
  end

  def name
    @name = [first_name,last_name].reject(&:blank?).join(' ').presence || "User #{id}"
  end

  def public_name
    if display_name?
      display_name
    else
      name
    end
  end

  def team_leader
    teams.first.try(:team_leader)
  end

  def is_prof?
    role == "professor"
  end

  def is_gsi?
    role == "gsi"
  end

  def is_student?
    role == "student" || role.blank?
  end

  def is_admin?
    role == "admin"
  end

  def role
    super || "student"
  end

  def is_staff?
    is_prof? || is_gsi? || is_admin?
  end

  #Grades

  def grade_level_for_course(course)
    course.grade_scheme.grade_level_for_course(score_for_course(course))
  end

  def earned_grades(course)
    grades.where(:course => course).to_a.sum { |g| g.score }
  end

  def grades_by_assignment_id
    @grades_by_assignment ||= grades.group_by(&:assignment_id)
  end

  def grade_for_assignment(assignment)
    grades_by_assignment_id[assignment.id].try(:first)
  end

  #Badges
  def earned_badges_value(course)
    earned_badges.where(:course => course).pluck('raw_score').sum
  end

  def earned_badges_by_badge_id
    @earned_badges_by_badge ||= earned_badges.group_by(&:badge_id)
  end

  def score_for_course(course)
    grades.where(course: course).score
  end
  

  # Calculates point total for graded assignments
  def point_total_for_course(course)
    c.assignments.joins('LEFT OUTER JOIN grades ON assignments.id = grades.assignment_id AND grades.student_id = 4').count
    grades.where(course: course).point_total
  end

  def score_for_assignment_type(assignment_type)
    grades.where(assignment_type: assignment_type).score
  end

  def weights_by_assignment_id
    @weights_by_assignment_id ||= Hash.new { |h, k| h[k] = 0 }.tap do |weights_hash|
      assignment_weights.each do |assignment_weight|
        weights_hash[assignment_weight.assignment_id] = assignment_weight.weight
      end
    end
  end

  def weight_for_assignment(assignment)
    weights_by_assignment_id[assignment.id]
  end

  def assignment_type_score(assignment_type)
    grades.for_assignemnt_type(assignment_type).sum { |g| g.score(self) }
  end

  #Import Users
  def self.csv_header
    "First Name,Last Name,Email,Username".split(',')
  end

  #Export Users and Final Scores
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["First Name", "Last Name", "Email", "Score", "Grade", "Logins", "Pageviews", "Predictor Views"]
      students.each do |user|
        csv << [user.first_name, user.last_name, user.email, user.score_for_course(course), user.grade_level(course), user.visit_count, user.page_views, user.predictor_views]
      end
    end
  end

   #Export Users and Final Scores for Course
  def self.csv_for_course(course, options = {})
    CSV.generate(options) do |csv|
      csv << ["First Name", "Last Name", "Email", "Score", "Grade", "Logins", "Pageviews", "Predictor Views"]
      course.users.students.each do |user|
        csv << [user.first_name, user.last_name, user.email, user.score_for_course(course), user.grade_level(course), user.visit_count, user.page_views, user.predictor_views]
      end
    end
  end

  #Calculates the total points available in a course, assuming that badges act as extra credit
  def total_points_for_course(course, in_progress = false)
    course.total_points(in_progress) + earned_badges_value(course)
  end

  def team_score(course)
    teams.where(:course => course).pluck('score').first
  end

  def group_for_assignment(assignment)
    groups.where(:assignment => assignment).first
  end

  private

  def set_default_course
    self.default_course ||= courses.first
  end

  def cache_scores
    course_memberships.each do |membership|
      membership.update_attribute :score, grades.where(course_id: membership.course_id).score
    end
  end
end

class User < ActiveRecord::Base
  authenticates_with_sorcery!

  include Canable::Cans

  before_validation :set_default_course
  after_save :cache_scores

  ROLES = %w(student professor gsi admin)

  ROLES.each do |role|
    scope role.pluralize, -> { where role: role }
  end

  attr_accessor :remember_me, :password, :password_confirmation, :cached_last_login_at
  attr_accessible :username, :email, :password, :password_confirmation,
    :avatar_file_name, :role, :first_name, :last_name, :rank, :user_id,
    :display_name, :private_display, :default_course_id, :last_activity_at,
    :last_login_at, :last_logout_at, :team_ids, :courses, :course_ids,
    :shared_badges, :earned_badges, :earned_badges_attributes,
    :remember_me_token, :major, :gpa, :current_term_credits, :accumulated_credits,
    :year_in_school, :state_of_residence, :high_school, :athlete, :act_score, :sat_score,
    :student_academic_history_attributes, :team_role, :course_memberships_attributes,
    :character_profile, :team_id, :lti_uid, :auditing

  #has_secure_password

  scope :alpha, -> { order 'last_name ASC' }
  scope :order_by_high_score, -> { order 'course_memberships.score DESC' }
  scope :order_by_low_score, -> { order 'course_memberships.score ASC' }
  scope :being_graded, -> { where('course_memberships.auditing IS FALSE') }
  scope :auditing, -> { where('course_memberships.auditing IS TRUE') }

  has_many :course_memberships
  has_one :student_academic_history, :foreign_key => :student_id, :dependent => :destroy, :class_name => 'StudentAcademicHistory'
  accepts_nested_attributes_for :student_academic_history
  has_many :courses, :through => :course_memberships
  accepts_nested_attributes_for :courses
  accepts_nested_attributes_for :course_memberships
  belongs_to :default_course, :class_name => 'Course'

  has_many :assignment_weights, :foreign_key => :student_id
  has_many :assignments, :through => :grades

  has_many :submissions, :foreign_key => :student_id, :dependent => :destroy
  has_many :created_submissions, :as => :creator
  has_many :grades, :foreign_key => :student_id, :dependent => :destroy
  has_many :graded_grades, foreign_key: :graded_by_id, :class_name => 'Grade'

  has_many :earned_badges, :foreign_key => :student_id, :dependent => :destroy
  accepts_nested_attributes_for :earned_badges, :reject_if => proc { |attributes| attributes['earned'] != '1' }

  has_many :badges, :through => :earned_badges

  has_many :group_memberships, :foreign_key => :student_id, :dependent => :destroy
  has_many :groups, :through => :group_memberships
  has_many :assignment_groups, :through => :groups
  has_many :team_memberships, :foreign_key => :student_id, :dependent => :destroy
  has_many :teams, :through => :team_memberships

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :username, :presence => true,
                    :length => { :maximum => 50 }
  validates :email, :presence => true,
                    :format   => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  def self.find_or_create_by_lti_auth_hash(auth_hash)
    criteria = { lti_uid: auth_hash['uid'] }
    where(criteria).first || create!(criteria) do |u|
      auth_hash['info'].tap do |info|
        u.email = info['email']
        u.first_name = info['first_name']
        u.last_name = info['last_name']
      end
      auth_hash['extra']['raw_info'].tap do |extra|
        u.username = extra['ext_sakai_eid']
        u.kerberos_uid = extra['ext_sakai_eid']
        case extra['roles']
        when 'instructor'
          u.role = 'professor'
        else
          u.role = 'student'
        end
      end
    end
  end

  def self.find_by_kerberos_auth_hash(auth_hash)
    where(kerberos_uid: auth_hash['uid']).first
  end

  #Course
  def find_scoped_courses(course_id)
    if is_admin? || self.course_ids.include?(course_id)
      Course.find(course_id)
    else
      raise
    end
  end

  def default_course
    courses.where(id: default_course_id) || courses.first
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

  def character_profile(course)
    course_memberships.where(course: course).try('character_profile')
  end

  #Submissions - can be taken out?

  def submissions_by_assignment_id
    @submissions_by_assignment ||= submissions.group_by(&:assignment_id)
  end

  def submission_for_assignment(assignment)
    submissions_by_assignment_id[assignment.id].try(:first)
  end

  #Badges - can be taken out?

  def earned_badges_by_badge_id
    @earned_badges_by_badge ||= earned_badges.group_by(&:badge_id)
  end

  def earned_badge_score_for_course(course)
    earned_badges.where(:course => course).score
  end

  #I think this may be a little bit faster - ch
  def scores_for_course(course)
     user_score = course_memberships.where(:course_id => course).pluck('score')
     scores = course.students.pluck('score')
     return {
      :scores => scores,
      :user_score => user_score
     }
  end

  def predictions(course)
    scores = []
    course.assignment_types.each do |assignment_type|
      scores << { data: [grades.released.where(assignment_type: assignment_type).score], name: assignment_type.name }
    end


    _assignments = assignments.where(course: course)
    in_progress = _assignments.graded_for_student(self)

    if course.valuable_badges? && course.has_team_challenges?
      earned_badge_score = earned_badges.where(course: course).score
      team_score = self.team_for_course(course).score
      scores << { :data => [team_score], :name => "#{course.challenge_term.pluralize}" }
      scores << { :data => [earned_badge_score], :name => "#{course.badge_term.pluralize}" }
      return {
        :student_name => name,
        :scores => scores,
        :course_total => course.total_points + earned_badge_score + team_score,
        :in_progress => in_progress.point_total + earned_badge_score + team_score
        }
    elsif course.valuable_badges?
      earned_badge_score = earned_badges.where(course: course).score
      scores << { :data => [earned_badge_score], :name => "#{course.badge_term.pluralize}" }
      return {
        :student_name => name,
        :scores => scores,
        :course_total => course.total_points + earned_badge_score,
        :in_progress => in_progress.point_total + earned_badge_score
        }
    elsif course.has_team_challenges?
      team_score = self.team_for_course(course).score
      scores << { :data => [team_score], :name => "#{course.challenge_term.pluralize}" }
      return {
        :student_name => name,
        :scores => scores,
        :in_progress => in_progress.point_total + team_score,
        :course_total => course.total_points + team_score
        }
    else
      return {
        :student_name => name,
        :scores => scores,
        :in_progress => in_progress.point_total,
        :course_total => course.total_points
        }
    end
  end

  #recalculating the student's score for the course
  def score_for_course(course)
    @score_for_course ||= grades.released.where(course: course).score + earned_badge_score_for_course(course) + (team_for_course(course).try(:challenge_grade_score) || 0)
  end

  #grabbing the stored score for the current course
  def cached_score_for_course(course)
    course_memberships.where(:course_id => course).first.score
  end

  #student setting as to whether or not they wish to share their earned badges for this course
  def badges_shared(course)
    course_memberships.any? { |m| m.course_id = course.id and m.shared_badges }
  end

  def grade_level_for_course(course)
    course.grade_level_for_score(cached_score_for_course(course))
  end

  def grade_letter_for_course(course)
    @grade_letter_for_course ||= course.grade_letter_for_score(cached_score_for_course(course))
  end

  def point_total_for_course(course)
    @point_total_for_course ||= course.assignments.point_total_for_student(self) + earned_badge_score_for_course(course)
  end

  def point_total_for_assignment_type(assignment_type)
    assignment_type.assignments.point_total_for_student(self)
  end

  def scores_by_assignment_type
    grades.group(:assignment_type_id).pluck('assignment_type_id, SUM(score)')
  end

  def score_for_assignment_type(assignment_type)
    grades.where(assignment_type: assignment_type).score
  end

  def released_score_for_assignment_type(assignment_type)
    grades.released.where(assignment_type: assignment_type).score
  end

  def weights_for_assignment_type_id(assignment_type)
    assignment_weights.where(assignment_type: assignment_type).weight
  end

  def weight_count(course)
    assignment_weights.where(course: course).pluck('weight').sum
  end

def groups_by_assignment_id
    @group_by_assignment ||= groups.group_by(&:assignment_id)
  end

  def group_for_assignment(assignment)
    assignment_groups.where(assignment: assignment).first.try(:group)
  end

  def team_for_course(course)
    teams.where(course: course).first
  end

  #Auditing Course

  def auditing_course?(course)
    course.membership_for_student(self).auditing?
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
        csv << [student.first_name, student.last_name, student.email, student.score_for_course(course), student.grade_level(course), student.visit_count, student.page_views, student.predictor_views]
      end
    end
  end

   #Export Users and Final Scores for Course
  def self.csv_for_course(course, options = {})
    CSV.generate(options) do |csv|
      csv << ["First Name", "Last Name", "Email", "Score", "Grade", "Logins", "Pageviews", "Predictor Views"]
      course.students.each do |student|
        csv << [student.first_name, student.last_name, student.email, student.score_for_course(course), student.visit_count, student.page_views, student.predictor_views]
      end
    end
  end

  def self.csv_roster_for_course(course, options = {})
    CSV.generate(options) do |csv|
      csv << ["First Name", "Last Name", "Uniqname", "Score", "Grade", "Feedback", "Team"]
      course.students.each do |student|
        csv << [student.first_name, student.last_name, student.username, "", "", "", student.team_for_course(course).try(:name) ]
      end
    end
  end

  def team_score(course)
    teams.where(:course => course).pluck('score').first
  end

  def default_course
    super || courses.first
  end

  private

  def set_default_course
    self.default_course ||= courses.first
  end

  def cache_scores
    course_memberships.each do |membership|
      membership.update_attribute :score, self.score_for_course(membership.course)
    end
  end

  def cache_last_login
    self.cached_last_login_at = self.last_login_at
  end
end

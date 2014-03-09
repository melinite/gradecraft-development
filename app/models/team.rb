class Team < ActiveRecord::Base
  attr_accessible :name, :course, :course_id, :student_ids, :score, :students, :teams_leaderboard, :in_team_leaderboard, :banner

  belongs_to :course

  has_many :team_memberships
  has_many :students, :through => :team_memberships

  mount_uploader :banner, ThumbnailUploader

  has_many :earned_badges, :through => :students

  has_many :challenge_grades
  has_many :challenges, :through => :challenge_grades

  after_validation :cache_score

  validates_presence_of :course, :name

  accepts_nested_attributes_for :team_memberships

  scope :alpha, -> { order 'name ASC' }
  scope :order_by_high_score, -> { order 'teams.score DESC' }
  scope :order_by_low_score, -> { order 'teams.score ASC' }

  def team_leader
    students.gsis.first
  end

  def sorted_students
    students.sort_by{ |student| - student.score_for_course(course) }
  end

  def member_count
    students.count
  end

  def badge_count
    earned_badges.count
  end

  def average_grade
    total_score = 0
    students.each do |student|
      total_score += (student.cached_score_for_course(course) || 0 )
    end
    if member_count > 0
      average_grade = total_score / member_count
    end
  end

  def challenge_grade_score
    challenge_grades.sum('score') || 0
  end

  private
  def cache_score
    if self.course.team_score_average?
      if self.score_changed?
        self.score = average_grade
      end
    else
      self.score = challenge_grades.sum('score')
    end
  end

  def cache_user_scores
    if self.course.team_score_average?
      students.save
    end
  end
end
class Team < ActiveRecord::Base
  attr_accessible :name, :course, :course_id, :student_ids

  belongs_to :course

  has_many :team_memberships
  has_many :students, :through => :team_memberships

  has_many :earned_badges, :as => :group

  has_many :challenges
  has_many :challenge_grades

  after_validation :cache_score

  validates_presence_of :course, :name

  def score
    challenge_grades.pluck('score').sum
  end

  def team_leader
    students.gsis.first
  end

  def member_count
    students.count
  end

  private

  def cache_score
    #self.update_attribute :score, challenge_grades.score
  end
end

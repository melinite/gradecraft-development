class Team < ActiveRecord::Base
  attr_accessible :name, :course, :course_id, :student_ids

  belongs_to :course

  has_many :team_memberships
  has_many :students, :through => :team_memberships

  has_many :earned_badges, :as => :group

  has_many :assignments, -> { team_assignment }
  has_many :grades, :as => :group

  #after_validation :cache_score

  #validates_presence_of :course, :name

  def score
    grades.pluck('raw_score').sum
  end

  def team_leader
    students.gsis.first
  end
end

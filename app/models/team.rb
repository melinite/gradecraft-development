class Team < ActiveRecord::Base
  self.table_name = 'groups'

  default_scope -> { where(:type => 'Team') }

  attr_accessible :name, :course, :course_id, :student_ids

  belongs_to :course

  has_many :group_memberships, :as => :group
  has_many :students, :through => :group_memberships, :source => :user

  has_many :earned_badges, :as => :group

  has_many :assignments, -> { team_assignment }
  has_many :grades, :as => :group

  #after_validation :cache_score

  #validates_presence_of :course, :name

  def score
    grades.pluck('raw_score').sum
  end
  
  def member_count
    students.count 
  end

  def team_leader
    students.gsis.first
  end
end

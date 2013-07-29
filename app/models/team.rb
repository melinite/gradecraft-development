class Team < ActiveRecord::Base
  self.table_name = 'groups'

  default_scope -> { where(:type => 'Team') }

  has_many :challenge_grades, :dependent => :destroy
  has_many :group_memberships, :as => :group
  has_many :students, :through => :group_memberships

  attr_accessible :name

  def user_grades
    Grade.where(:student => members)
  end

  def score
    challenge_grades.pluck('raw_score').sum
  end

  def badge_count
    earned_badges.count
  end

  def member_count
    #member.count
  end

  def member_badge_count
    member.sum(&:user_badge_count)
  end

  def team_leader
    students.gsis.first
  end

  def students_by_team_id
    @students_by_team_id ||= members.group_by(&:team_id)
  end

  def students_in_team(team)
    students_by_team_id[team.id].try(:first)
  end

  def membership_for_student(student)
    memberships_by_student_id[student.id] || team_memberships.new(:user_id => student.id)
  end

  private

  def memberships_by_student_id
    @memberships_by_student_id ||= {}.tap do |m|
      team_memberships.each do |membership|
        m[membership.user_id] = membership
      end
    end
  end
end

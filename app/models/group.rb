class Group < ActiveRecord::Base
  MAX_MEMBERS = 6

  attr_accessible :name, :created_at, :updated_at, :proposal, :approved,
    :assignment_id, :user_ids, :text_proposal, :student_ids, :assignment_ids

  belongs_to :course

  has_many :assignment_groups
  has_many :assignments, :through => :assignment_groups

  has_many :group_memberships
  has_many :students, :through => :group_memberships

  has_many :submissions

  has_many :earned_badges, :as => :group

  validates_presence_of :course, :name

  #Grades

  def submissions_by_assignment_id
    @submissions_by_assignment ||= submissions.group_by(&:assignment_id)
  end

  def submission_for_assignment(assignment)
    submissions_by_assignment_id[assignment.id].try(:first)
  end

  #Badges

  def earned_badges_by_badge_id
    @earned_badges_by_badge ||= earned_badges.group_by(&:badge_id)
  end



  private

  def cache_score
    #self.course_id = challenge_grades.pluck('score').sum
  end
end

class Group < ActiveRecord::Base
  MAX_MEMBERS = 6

  attr_accessible :name, :created_at, :updated_at, :proposal, :approved,
    :assignment_id, :user_ids, :text_proposal, :student_ids, :assignment_ids

  belongs_to :course

  has_many :assignment_groups
  has_many :assignments, :through => :assignment_groups

  has_many :group_memberships
  has_many :students, :through => :group_memberships

  has_many :earned_badges, :as => :group

  validates_presence_of :course, :name

  def cache_score
    #self.course_id = challenge_grades.pluck('score').sum
  end
end

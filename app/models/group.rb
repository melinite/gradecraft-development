class Group < ActiveRecord::Base
  MAX_MEMBERS = 6

  APPROVED_STATUSES = ['Pending', 'Approved', 'Rejected']

  attr_accessible :name, :proposal, :approved, :assignment_id, :assignment_ids,
    :text_proposal, :student_ids, :students, :assignment_groups_attributes, :group_membership_attributes

  belongs_to :course

  has_many :assignment_groups, :dependent => :destroy
  has_many :assignments, :through => :assignment_groups
  accepts_nested_attributes_for :assignment_groups

  has_many :group_memberships, :dependent => :destroy
  has_many :students, :through => :group_memberships
  accepts_nested_attributes_for :group_memberships

  has_many :grades

  has_many :submissions

  has_many :earned_badges, :as => :group

  before_validation :cache_associations

  validates_presence_of :course, :name

  validate :max_group_number_not_exceeded, :min_group_number_met

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

  def min_group_number_met
    if self.students.to_a.count < course.min_group_size
      errors.add(:group, "Nope, not enough group members!")
    end
  end

  def max_group_number_not_exceeded
    if self.students.to_a.count > course.max_group_size
      errors.add(:group, "Woah, too many group members, try again.")
    end
  end

  def cache_associations
    self.course_id ||= assignment.try(:course_id)
  end
end

class AbstractGroup < ActiveRecord::Base
  self.table_name = 'groups'

  validates_presence_of :name, :course

  has_many :earned_badges, :as => :gradeable, :dependent => :destroy
  has_many :badges, :through => :earned_badges

  has_many :submissions, :as => :submittable, :dependent => :destroy

  belongs_to :course

  has_many :group_memberships
  has_many :users, :through => :group_memberships

  def grades_by_assignment_id
    @grades_by_assignment ||= grades.group_by(&:assignment_id)
  end

  def grade_for_assignment(assignment)
    grades_by_assignment_id[assignment.id].try(:first)
  end
end

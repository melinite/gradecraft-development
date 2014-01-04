class GroupMembership < ActiveRecord::Base
  attr_accessible :accepted, :group, :group_id, :student, :student_id

  belongs_to :group
  belongs_to :student, class_name: 'User'

  validates_uniqueness_of :student_id, { :scope => :group_id }

end

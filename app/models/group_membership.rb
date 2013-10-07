class GroupMembership < ActiveRecord::Base
  attr_accessible :accepted, :group, :group_id, :student, :student_id

  belongs_to :group
  belongs_to :student, class_name: 'User'
end

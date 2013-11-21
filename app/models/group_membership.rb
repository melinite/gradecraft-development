class GroupMembership < ActiveRecord::Base
  attr_accessible :accepted, :group, :group_id, :student, :student_id

  belongs_to :group
  belongs_to :student, class_name: 'User'

  #validates :student_id, :uniqueness => { :scope => [ :student_id, :assignment_id ] }

end

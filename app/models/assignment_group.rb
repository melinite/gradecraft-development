class AssignmentGroup < ActiveRecord::Base

  attr_accessible :assignment, :assignment_id, :group, :group_id

  belongs_to :assignment
  belongs_to :group

  #validates :assignment_id, :uniqueness => { scope: [:student_id, :group_id] }
end
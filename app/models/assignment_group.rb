class AssignmentGroup < ActiveRecord::Base

  attr_accessible :assignment, :group

  belongs_to :assignment
  belongs_to :group

end
class AssignmentScoreLevel < ActiveRecord::Base
  belongs_to :assignment

  attr_accessible :name, :value, :assignment_id

end
class AssignmentScoreLevel < ActiveRecord::Base
  belongs_to :assignment

  attr_accessible :name, :value, :assignment_id

  validates_presence_of :value, :name

end
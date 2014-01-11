class AssignmentScoreLevel < ActiveRecord::Base
  belongs_to :assignment

  attr_accessible :name, :value, :assignment_id

  validates_presence_of :value, :name
  scope :order_by_value, -> { order 'value DESC' }

end
class ScoreLevel < ActiveRecord::Base
  belongs_to :assignment_type
  belongs_to :assignment
  belongs_to :challenge

  attr_accessible :name, :value, :assignment_id, :assignment_type_id

  validates_presence_of :value, :name
  scope :order_by_value, -> { order 'value DESC' }
  #validate :score_level_cannot_exceed_lowest_assignment_point_value


  def score_level_cannot_exceed_lowest_assignment_point_value
    assignment_type_value = self.assignment_type.max_value if self.assignment_type
    assignments = self.assignment_type.assignments if self.assignment_type
    if assignment_type_value.present? && self.value > assignment_type_value
      errors.add(:value, "cannot be greater than the assignment type max value (#{assignment_type_value})")
    elsif assignments.present? && assignments.any?
      min_assignment_value = assignments.minimum(:point_total)
      if self.value > min_assignment_value
        errors.add(:value, "cannot be greater than the lowest assignment's point value (#{min_assignment_value})")
      end
    end
  end

end
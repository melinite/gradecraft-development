class AssignmentTypeWeight < Struct.new(:student, :assignment_type)
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :weight

  def weight
    @weight ||= assignment_type.assignment_weights.where(student: student).weight
  end

  def assignment_type_id
    assignment_type.id
  end

  def persisted?
    false
  end

  def save
    if valid?
      save_assignment_weights
      true
    else
      false
    end
  end

  def save_assignment_weights
    assignment_type.assignments.each do |assignment|
      assignment.weights.where(student: student).first_or_initialize.update_attributes(weight: weight)
    end
  end
end

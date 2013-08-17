class AssignmentTypeWeight < Struct.new(:student, :assignment_type)
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :weight

  validate :course_max_assignment_weight_not_exceeded

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

  private

  def save_assignment_weights
    assignment_type.assignments.each do |assignment|
      assignment_weight = assignment.weights.where(student: student).first_or_initialize
      assignment_weight.weight = weight
      assignment_weight.save!
    end
  end

  def course_max_assignment_weight_not_exceeded
    if weight > assignment_type.course.max_assignment_weight
      errors.add :weight, "exceeded maximum allowed for course"
    end
  end
end

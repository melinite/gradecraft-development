class AssignmentTypeWeightForm < Struct.new(:student, :course)
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion

  def initialize(student, course)
    super(student, course)
    @errors = ActiveModel::Errors.new(self)
  end

  attr_reader :assignment_type_weights, :errors

  validate :course_total_assignment_weight_not_exceeded

  def update_attributes(attributes)
    self.assignment_type_weights_attributes = attributes[:assignment_type_weights_attributes]
    self.save
  end

  def save
    if valid?
      assignment_type_weights.map(&:save)
      true
    else
      false
    end
  end

  def valid?
    super && assignment_type_weights.all?(&:valid?)
  end

  def assignment_type_weights
    @assignment_type_weights ||= course.assignment_types.student_weightable.map do |assignment_type|
      AssignmentTypeWeight.new(student, assignment_type)
    end
  end

  def assignment_type_weights_attributes=(attributes_collection)
    @assignment_type_weights = attributes_collection.map do |key, attributes|
      AssignmentTypeWeight.new(student, AssignmentType.find(attributes['assignment_type_id'])).tap do |assignment_type_weight|
        assignment_type_weight.weight = attributes['weight'].to_i
      end
    end
  end

  def course_total_assignment_weight
    assignment_type_weights.sum(&:weight)
  end

  private

  def course_total_assignment_weight_not_exceeded
    if course_total_assignment_weight > course.total_assignment_weight
      errors.add :base, "exceeded maximum total allowed for course"
    end
  end
end

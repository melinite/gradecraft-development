class AssignmentTypeWeightForm < Struct.new(:student, :course)
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_reader :assignment_type_weights

  validate :validate_course_total_assignment_weight
  validate :validate_assignment_type_weights

  def update_attributes(attributes)
    self.assignment_type_weights_attributes = attributes[:assignment_type_weights_attributes]
    save
  end

  def save
    if valid?
      assignment_type_weights.map(&:save)
      true
    else
      false
    end
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

  def validate_course_total_assignment_weight
    if course_total_assignment_weight > course.total_assignment_weight
      errors.add :base, "You have allocated more than the course total"
    elsif course_total_assignment_weight < course.total_assignment_weight
      errors.add :base, "You must allocate the entire course total"
    end
  end

  def validate_assignment_type_weights
    assignment_type_weights.each do |assignment_type_weight|
      if !assignment_type_weight.valid?
        assignment_type_weight.errors.each do |attribute, message|
          attribute = "assignment_type_weights.#{attribute}"
          errors[attribute] << message
          errors[attribute].uniq!
        end
      end
    end
  end
end

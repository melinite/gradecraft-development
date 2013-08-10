class AssignmentTypeWeightForm < Struct.new(:student, :course)
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_reader :assignment_type_weights

  def update_attributes(attributes)
    self.assignment_type_weights_attributes = attributes[:assignment_type_weights_attributes]
    self.save
  end

  def save
    false
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
end

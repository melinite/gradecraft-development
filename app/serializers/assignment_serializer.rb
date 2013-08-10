class AssignmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :point_total, :due_at,
    :assignment_type_id, :grade_scheme_id, :grade_scope, :visible, :required
end

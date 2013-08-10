class AssignmentRubric < ActiveRecord::Base
  attr_accessible :assignment, :assignment_id, :rubric, :rubric_id

  delegate :name, :description, :to => :rubric

  belongs_to :assignment
  belongs_to :rubric
end

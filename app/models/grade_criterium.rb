class GradeCriterium < ActiveRecord::Base
  attr_accessible :score, :criterium_id, :criterium

  belongs_to :grade
  belongs_to :criterium
  belongs_to :assignment
  belongs_to :course
  belongs_to :student, class_name: 'User'

  before_validation :cache_associations

  private

  def cache_associations
    self.assignment = grade.try(:assignment)
    self.course = grade.try(:course)
    self.student = grade.try(:student)
  end
end

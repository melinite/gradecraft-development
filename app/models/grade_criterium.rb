class GradeCriterium < ActiveRecord::Base
  belongs_to :criterium
  belongs_to :rubric
  belongs_to :course
  belongs_to :assignment
  belongs_to :criterium_level
end

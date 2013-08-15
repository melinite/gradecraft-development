class ScoreLevel < ActiveRecord::Base
  belongs_to :assignment_type
  belongs_to :assignment
  belongs_to :challenge

  attr_accessible :name, :value, :assignment_id, :assignment_type_id

end
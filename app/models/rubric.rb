class Rubric < ActiveRecord::Base
  belongs_to :assignment
  has_many :metrics
  has_many :rubric_grades

  validates :assignment, presence: true
end

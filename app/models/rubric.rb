class Rubric < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :assignment_rubrics, dependent: :destroy
  has_many :assignments, through: :assignment_rubrics
  belongs_to :course

  validates_presence_of :course, :name, :description

  has_many :criteria
  has_many :criteria_levels, :through => :criteria
end

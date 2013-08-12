class Rubric < ActiveRecord::Base
  attr_accessible :description, :name

  belongs_to :course
  has_many :assignment_rubrics, dependent: :destroy
  has_many :assignments, through: :assignment_rubrics
  has_many :categories, class_name: 'RubricCategory'
  accepts_nested_attributes_for :categories

  validates_presence_of :course, :name, :description

  has_many :criteria
  has_many :criteria_levels, :through => :criteria
end

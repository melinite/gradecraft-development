class RubricCategory < ActiveRecord::Base
  belongs_to :rubric
  has_many :criteria

  attr_accessible :name

  validates_presence_of :name
end

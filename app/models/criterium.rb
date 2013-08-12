class Criterium < ActiveRecord::Base
  attr_accessible :description, :name, :category, :rubric, :ruberic_id

  belongs_to :rubric
  has_many :criteria_levels

  validates_presence_of :name, :rubric, :category

  def self.categories
    distinct.order('category ASC').pluck('category')
  end

  def name
    "#{super} (#{category})"
  end
end

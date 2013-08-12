class Criterium < ActiveRecord::Base
  attr_accessible :description, :name, :category, :rubric, :ruberic_id,
    :levels_attributes

  belongs_to :rubric
  has_many :levels, class_name: 'CriteriumLevel'
  accepts_nested_attributes_for :levels, allow_destroy: true

  validates_presence_of :name, :rubric, :category

  def self.categories
    distinct.order('category ASC').pluck('category')
  end

  def name
    "#{super} (#{category})"
  end
end

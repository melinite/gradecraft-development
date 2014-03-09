class Metric < ActiveRecord::Base
  belongs_to :rubric
  has_many :tiers

  validates :max_points, presence: true
  validates :name, presence: true
  validates :order, presence: true
end

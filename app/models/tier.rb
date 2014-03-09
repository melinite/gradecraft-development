class Tier < ActiveRecord::Base
  belongs_to :metric

  validates :points, presence: true
  validates :name, presence: true
end

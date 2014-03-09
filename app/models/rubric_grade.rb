class RubricGrade < ActiveRecord::Base
  belongs_to :submission

  validates :max_points, presence: true
  validates :metric_name, presence: true
  validates :order, presence: true
  validates :tier_name, presence: true
  validates :points, presence: true
  validates :submission_id, presence: true
end

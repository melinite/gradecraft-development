class GradeSchemeElement < ActiveRecord::Base
  attr_accessible :letter, :low_range, :high_range, :level, :description, :course_id

  belongs_to :course

  validates_presence_of :low_range, :high_range
  validates_numericality_of :high_range, greater_than: Proc.new { |e| e.low_range.to_i }

  scope :order_by_low_range, -> { order 'low_range ASC' }
  scope :order_by_high_range, -> { order 'high_range DESC' }

  def element_name
    if level?
      level
    else
      letter
    end
  end

  def overlap?(element)
    element.low_range <= high_range && element.high_range >= low_range
  end
end

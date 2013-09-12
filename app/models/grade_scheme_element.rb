class GradeSchemeElement < ActiveRecord::Base
  attr_accessible :letter, :low_range, :high_range, :level, :grade_scheme,
    :grade_scheme_id, :description

  belongs_to :grade_scheme, inverse_of: :elements

  validates_presence_of :grade_scheme
  validates_presence_of :low_range, :high_range
  validates_numericality_of :high_range, greater_than: Proc.new { |e| e.low_range.to_i }

  scope :order_by_low_range, -> { order 'grade_scheme_elements.low_range ASC' }

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

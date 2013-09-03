class GradeSchemeElement < ActiveRecord::Base
  attr_accessible :letter, :low_range, :high_range, :level, :grade_scheme,
    :grade_scheme_id, :description

  belongs_to :grade_scheme

  validates_presence_of :grade_scheme, :low_range, :high_range
  validates_numericality_of :high_range, greater_than: Proc.new { |e| e.low_range.to_i }

  validate :does_not_overlap_another_range

  scope :order_by_low_range, -> { order 'grade_scheme_elements.low_range ASC' }

  def element_name
    if level?
      level
    else
      letter
    end
  end

  private

  def does_not_overlap_another_range
    elements = grade_scheme.elements
    elements.where('id != ?', id) if persisted?
    if elements.where('low_range <= ? AND high_range > ?', high_range, high_range).present?
      errors.add(:high_range, "must not overlap another range")
    end
  end
end

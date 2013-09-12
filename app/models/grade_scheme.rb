class GradeScheme < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :course
  has_many :elements, :class_name => 'GradeSchemeElement', inverse_of: :grade_scheme
  accepts_nested_attributes_for :elements

  attr_accessible :created_at, :updated_at, :name, :course_id, :description,
    :course, :elements_attributes

  validates_presence_of :name, :course
  validate :elements_do_not_overlap

  def level(score)
    elements.where('low_range <= ? AND high_range >= ?', score, score).pluck('level').first
  end

  def letter(score)
    elements.where('low_range <= ? AND high_range >= ?', score, score).pluck('letter').first
  end

  private

  def elements_do_not_overlap
    ordered_elements = elements.sort_by(&:low_range)
    ordered_elements.each_with_index do |element, i|
      next unless i > 0
      previous = ordered_elements[i - 1]
      element.errors.add(:high_range, "must not overlap another range") if element.overlap?(previous)
    end
  end
end

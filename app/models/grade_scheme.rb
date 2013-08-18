class GradeScheme < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :course
  has_many :elements, :class_name => 'GradeSchemeElement'
  accepts_nested_attributes_for :elements

  attr_accessible :created_at, :updated_at, :name, :course_id, :description,
    :course, :elements_attributes

  validates_presence_of :name, :course

  def level(score)
    elements.where('low_range <= ? AND high_range >= ?', score, score).pluck('level').first
  end

  def letter(score)
    elements.where('low_range <= ? AND high_range >= ?', score, score).pluck('letter').first
  end
end

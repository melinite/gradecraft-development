class GradeScheme < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :course
  has_many :elements, :class_name => 'GradeSchemeElement'
  
  attr_accessible :created_at, :updated_at, :name, :course_id, :description, :course
  
  validates_presence_of :name, :course_id
  
  before_save :high_range_greater_than_low

  def element_levels
    @levels ||= {}.tap do |levels|
      elements.each do |element|
        levels[[element.low_range,element.high_range]] = element.level
      end
    end
  end
  
  def letters
    @letters ||= {}.tap do |letters|
      elements.each do |element|
        letters[[element.low_range,element.high_range]] = element.letter
      end
    end
  end
  
  def grade_level(unmultiplied_score)
    levels.each do |range,level|
      return level if unmultiplied_score.between?(*range)
    end
    nil
  end
  
  def grade_letter(unmultiplied_score)
    letters.each do |range,letter|
      return letter if unmultiplied_score.between?(*range)
    end
    nil
  end
  
  
  private
  
  def grade_level(grade)
    score_levels.each do |score_level|
      return score_level.name if grade.raw_score == score_level.value
    end
    nil
  end
  
  def high_range_greater_than_low
    elements.order('low_range ASC, high_range ASC').each_with_index do |element, i|
      if elements[i + 1]
        if element.high_value >= elements[i + i].low_value
          element.errors.add(:high_range, "Your score ranges for each level cannot overlap.")
        end
      end
    end
  end
end

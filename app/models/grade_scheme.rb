class GradeScheme < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :course
  has_many :grade_scheme_elements
  
  attr_accessible :created_at, :updated_at, :name, :course_id, :description, :course
  
  validates_presence_of :name, :course_id

  def element_names
    @names ||= {}.tap do |names|
      grade_scheme_elements.each do |element|
        names[[element.low_range,element.high_range]] = element.element_name
      end
    end
  end
  
  def letter_grades
    @letter_grades ||= {}.tap do |letter_grades|
      grade_scheme_elements.each do |element|
        letter_grades[[element.low_range,element.high_range]] = element.letter_grade
      end
    end
  end
  
  def grade_level(unmultiplied_score)
    element_names.each do |range,name|
      return name if unmultiplied_score.between?(*range)
    end
    nil
  end
  
  def grade_letter(unmultiplied_score)
    letter_grades.each do |range,letter_grade|
      return letter_grade if unmultiplied_score.between?(*range)
    end
    nil
  end
  
end

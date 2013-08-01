class GradeSchemeElement < ActiveRecord::Base
  attr_accessible :letter, :low_range, :high_range, :level, :grade_scheme_id, :description
  
  belongs_to :grade_scheme
  
  validates_presence_of :low_range, :high_range
  

  def element_name
    if level?
      level
    else 
      letter
    end
  end
  
  

end

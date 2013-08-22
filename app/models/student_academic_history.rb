class StudentAcademicHistory < ActiveRecord::Base

  attr_accessible :student_id, :major, :gpa, :current_term_credits, :accumulated_credits, :year_in_school,
  :state_of_residence, :high_school, :athlete, :act_score, :sat_score

  belongs_to :user, :foreign_key => :student_id

end
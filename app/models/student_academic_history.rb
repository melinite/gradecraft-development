class StudentAcademicHistory < ActiveRecord::Base

  belongs_to :student, :class_name => 'User', :foreign_key => :student_id

  attr_accessible :student_id, :major, :gpa, :current_term_credits, :accumulated_credits, :year_in_school,
  :state_of_residence, :high_school, :athlete, :act_score, :sat_score


end
class TeamMembership < ActiveRecord::Base
  attr_accessible :team, :team_id, :student, :student_id

  belongs_to :team
  belongs_to :student, class_name: 'User'

  validates_presence_of :team, :student
end

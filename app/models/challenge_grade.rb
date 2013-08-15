class ChallengeGrade < ActiveRecord::Base

  attr_accessible :name, :course_id, :rank, :score

  belongs_to :course
  belongs_to :challenge
  belongs_to :team
  belongs_to :submission # Optional
  belongs_to :task # Optional

  delegate :name, :description, :due_at, :point_total, :to => :challenge

end
class ChallengeGrade < ActiveRecord::Base

  attr_accessible :name, :course_id, :rank, :score, :challenge_id, :feedback, :status, :team_id, :final_score

  belongs_to :course
  belongs_to :challenge
  belongs_to :team
  belongs_to :submission # Optional
  belongs_to :task # Optional

  validates_presence_of :team, :challenge

  delegate :name, :description, :due_at, :point_total, :to => :challenge

  private

  def save_team
    team.save
  end
end
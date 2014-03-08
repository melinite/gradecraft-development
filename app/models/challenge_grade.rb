class ChallengeGrade < ActiveRecord::Base

  attr_accessible :name, :course_id, :rank, :score, :challenge_id, :text_feedback, :status, :team_id, :final_score, :status, :team, :challenge

  belongs_to :course
  belongs_to :challenge
  belongs_to :team
  belongs_to :submission # Optional
  belongs_to :task # Optional

  validates_presence_of :team, :challenge

  after_save :save_team

  delegate :name, :description, :due_at, :point_total, :to => :challenge

  def score
    super.presence || 0
  end
  
  private

  def save_team
    if self.score_changed?
      team.save
    end
  end

end
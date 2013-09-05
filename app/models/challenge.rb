class Challenge < ActiveRecord::Base

  attr_accessible :assignment, :assignment_id, :name, :description, :icon,
    :visible, :created_at, :updated_at, :image_file_name, :occurrence,
    :badge_set, :category_id, :value, :multiplier, :point_total, :due_date,
    :accepts_submissions, :release_necessary, :course

  belongs_to :course
  has_many :submissions
  has_many :challenge_grades
  has_many :score_levels

  validates_presence_of :course, :name

  def has_levels?
    levels == true
  end

  def mass_grade?
    mass_grade = true
  end

  def challenge_grades_by_team_id
    @challenge_grade_for_team ||= challenge_grades.group_by(&:team_id)
  end

  def challenge_grade_for_team(team)
    challenge_grades_by_team_id[team.id].try(:first)
  end

  def challenge_submissions_by_team_id
    @challenge_submissions_by_team ||= challenge_submissions.group_by(&:team_id)
  end

  def challenge_submission_for_team(team)
    challenge_submissions_by_team_id[team.id].try(:first)
  end

end
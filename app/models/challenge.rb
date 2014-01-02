class Challenge < ActiveRecord::Base

  attr_accessible :assignment, :assignment_id, :name, :description, :icon,
    :visible, :created_at, :updated_at, :image_file_name, :occurrence,
    :category_id, :value, :multiplier, :point_total, :due_at,
    :accepts_submissions, :release_necessary, :course,
    :challenge_file_ids, :challenge_files_attributes, :challenge_file

  belongs_to :course
  has_many :submissions
  has_many :challenge_grades
  has_many :score_levels
  has_many :challenge_files, :dependent => :destroy
  accepts_nested_attributes_for :challenge_files

  validates_presence_of :course, :name

  scope :chronological, -> { order('due_at ASC') }
  scope :alphabetical, -> { order('name ASC') }

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

  def future?
    due_at != nil && due_at >= Date.today
  end

end
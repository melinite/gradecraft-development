class EarnedBadge < AbstractGrade
  belongs_to :grade, :foreign_key => :parent_id
  belongs_to :badge, :foreign_key => :assignment_id

  before_validation :set_badge_and_course

  validates_presence_of :assignment

  delegate :name, :description, :to => :badge

  private

  def set_badge_and_course
    self.badge_id = submission.assignment_id
    self.course_id = badge.course_id
  end
end

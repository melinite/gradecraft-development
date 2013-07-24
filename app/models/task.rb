class Task < AbstractTask
  attr_accessible :assignment

  belongs_to :assignment
  belongs_to :badge, :foreign_key => :assignment_id
  belongs_to :course
  has_many :submissions, :dependent => :destroy

  before_validation :set_course

  validates_presence_of :assignment, :course

  private

  def set_course
    self.course_id = assignment.course_id
  end
end

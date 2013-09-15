class Task < ActiveRecord::Base
  attr_accessible :assignment, :assignment_id, :assignment_type, :name, :description, :due_at

  belongs_to :assignment, :polymorphic => true
  belongs_to :course
  has_many :submissions, :dependent => :destroy

  before_validation :set_course

  validates_presence_of :assignment, :course

  private

  def set_course
    self.course_id = assignment.try(:course_id)
  end
end

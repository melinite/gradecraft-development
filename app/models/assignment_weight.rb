class AssignmentWeight < ActiveRecord::Base
  attr_accessible :student, :student_id, :assignment, :assignment_id, :weight

  include Canable::Ables

  belongs_to :student, :class_name => 'User'
  belongs_to :assignment_type
  belongs_to :assignment

  before_save :set_assignment_type_id

  validates_presence_of :student, :assignment
  validate :course_total_assignment_weight_not_exceeded,
    :course_max_assignment_weight_not_exceeded

  scope :except_weight, ->(weight) { where('assignment_weights.id != ?', weight.id) }
  scope :for_course, ->(course) { where(:assignment_id => course.assignments.pluck(:id)) }

  delegate :course, :to => :assignment, :allow_nil => false

  def updatable_by?(user)
    self.student_id == student.id
  end

  def destroyable_by?(user)
    updatable_by?(user)
  end

  def viewable_by?(user)
    updatable_by?(user)
  end

  def total_assignment_weight
    course.assignment_weight_for_student(student) + (persisted? ? 0 : weight)
  end

  private

  def course_total_assignment_weight_not_exceeded
    if total_assignment_weight > course.total_assignment_weight
      errors.add(:weight, "exceeded maximum total allowed for course. Please select a lower #{course.weight_term.downcase}")
    end
  end

  def course_max_assignment_weight_not_exceeded
    if weight > course.max_assignment_weight
      errors.add(:weight, "exceeded maximum allowed for course. Please select a lower #{course.weight_term.downcase}")
    end
  end

  def set_assignment_type_id
    self.assignment_type_id = assignment.assignment_type_id
  end
end

class Badge < ActiveRecord::Base
  self.table_name = 'assignments'

  default_scope -> { where(:type => 'Badge') }

  attr_accessible :assignment, :assignment_id, :name, :description, :icon,
    :visible, :created_at, :updated_at, :image_file_name, :occurrence,
    :badge_set, :category_id, :value, :multiplier

  has_many :earned_badges, :foreign_key => :assignment_id, :dependent => :destroy
  has_many :tasks, :foreign_key => :assignment_id, :dependent => :destroy
  belongs_to :badge_set, :foreign_key => :category_id
  belongs_to :course
  #belongs_to :assignment

  has_many :submissions
  accepts_nested_attributes_for :badge_set

  before_validation :set_course

  validates_presence_of :course, :name

  scope :ordered, -> { 'assignments.id ASC' }

  def can_earn_multiple_times
    super || false
  end

  def point_value
    if value
      value
    else
      0
    end
  end

  #badges per role
  def earned_badges_by_earnable_id
    @earned_badges_by_earnable_id ||= earned_badges.group_by { |eb| [eb.earnable_type, eb.earnable_id] }
  end

  def earned_badge_for_student(student)
    earned_badges_by_earnable_id[['User',student.id]].try(:first)
  end

  def grade_scope
    'Individual'
  end

  private

  def set_course
    self.course_id = badge_set.try(:course_id)
  end
end

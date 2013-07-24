class Badge < Assignment
  attr_accessible :assignment_id, :name, :description, :icon, :visible, :created_at, 
  :updated_at, :image_file_name, :occurrence, :badge_set_id, :value, :multiplier

  #has_attached_file :image, :styles => { :small => "70x70>" }

  #mount_uploader :icon, ImageUploader
  has_many :earned_badges, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  belongs_to :badge_set
  belongs_to :course
  belongs_to :assignment

  accepts_nested_attributes_for :badge_set

  before_validation :set_course

  validates_presence_of :course, :name

  scope :ordered, -> { 'badges.id ASC' }

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

  def assignment_type
    self
  end

  def badges_earned
    EarnedBadge.where(:badge_id => id)
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
    self.course_id = badge_set.course_id
  end
end

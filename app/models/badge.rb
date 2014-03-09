class Badge < ActiveRecord::Base
   attr_accessible :name, :description, :icon, :visible, :can_earn_multiple_times, 
    :value, :multiplier, :point_total, :earned_badges, :earned_badges_attributes, :score, :badge_file_ids, :badge_files_attributes, :badge_file

  mount_uploader :icon, BadgeIconUploader

  has_many :earned_badges, :dependent => :destroy

  has_many :tasks, :as => :assignment, :dependent => :destroy
  belongs_to :course

  accepts_nested_attributes_for :earned_badges, allow_destroy: true

  has_many :submissions, as: :assignment

  has_many :badge_files, :dependent => :destroy
  accepts_nested_attributes_for :badge_files

  validates_presence_of :course, :name

  scope :ordered, -> { 'assignments.id ASC' }

  def self.with_earned_badge_info_for_student(student)
    joins("LEFT JOIN earned_badges on badges.id = earned_badges.id AND earned_badges.student_id = #{Badge.sanitize(student.id)}").select('badges.*, earned_badges.created_at AS earned_at, earned_badges.feedback')
  end

  def can_earn_multiple_times
    super || false
  end

  #badges per role
  def earned_badges_by_student_id
    @earned_badges_by_student_id ||= earned_badges.group_by { |eb| [eb.student_id] }
  end

  def earned_badge_for_student(student)
    earned_badges_by_student_id[[student.id]].try(:first)
  end

end

class Grade < AbstractGrade
  include Canable::Ables

  attr_accessible :type, :raw_score, :final_score, :feedback, :assignment,
    :assignment_id, :badge_id, :created_at, :updated_at, :complete, :semis,
    :finals, :status, :attempted, :substantial, :user, :badge_ids, :grade,
    :gradeable, :gradeable_id, :gradeable_type, :earned_badges_attributes,
    :earned, :submission, :submission_id, :badge_ids, :earned_badge_id,
    :gradeable_attributes, :earned_badges, :earned_badges_attributes

  belongs_to :submission
  belongs_to :assignment
  has_many :grade_scheme_elements, :through => :assignment

  has_many :earned_badges, :dependent => :destroy
  accepts_nested_attributes_for :earned_badges

  has_many :badges, :through => :earned_badges

  before_validation :set_assignment_and_course

  validates_presence_of :assignment
  validates_uniqueness_of :assignment_id, :scope => [:gradeable_id, :gradeable_type]

  delegate :name, :description, :due_date, :assignment_type, :to => :assignment

  after_save :save_gradeable
  after_destroy :save_gradeable

  scope :completion, -> { where(order: "assignments.due_date ASC", :joins => :assignment) }
  scope :released, -> { where(status: "Released") }

  def raw_score
    super || 0
  end

  def score(student)
    if final_score?
      final_score
    else
      (raw_score * weight_for_student(student)).to_i
    end
  end

  def unweighted_score
    if final_score?
      final_score
    else
      raw_score
    end
  end

  def point_total(student)
    assignment.point_total * weight_for_student(student)
  end

  def weight_for_student(student)
    assignment.weight_for_student(student)
  end

  def has_feedback?
    feedback != "" && feedback != nil
  end

  def is_released?
    status == "Released"
  end

  #Canable Permissions
  def updatable_by?(user)
    creator == user
  end

  def creatable_by?(user)
    gradeable_id = user.id
  end

  def viewable_by?(user)
    gradeable_id == user.id
  end

  def self.to_csv(options = {})
    #CSV.generate(options) do |csv|
      #csv << ["First Name", "Last Name", "Score", "Grade"]
      #students.each do |user|
        #csv << [user.first_name, user.last_name]
        #, user.earned_grades(course), user.grade_level(course)]
      #end
    #end
  end

  private

  def save_gradeable
    gradeable.save
  end

  def set_assignment_and_course
    self.assignment_id = submission.assignment_id
    self.course_id = submission.assignment.course_id
  end
end

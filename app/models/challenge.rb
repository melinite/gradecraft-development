class Challenge < ActiveRecord::Base

  attr_accessible :assignment, :assignment_id, :name, :description, :icon,
    :visible, :created_at, :updated_at, :image_file_name, :occurrence,
    :badge_set, :category_id, :value, :multiplier, :point_total, :due_date,
    :accepts_submissions, :release_necessary, :course

  has_many :tasks, :foreign_key => :assignment_id, :dependent => :destroy
  belongs_to :course
  has_many :submissions

  validates_presence_of :course, :name


end
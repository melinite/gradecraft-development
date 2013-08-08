class BadgeSet < ActiveRecord::Base
  attr_accessible :course, :course_id, :name, :description

  belongs_to :course
  has_many :badges

  validates_presence_of :course, :name
end

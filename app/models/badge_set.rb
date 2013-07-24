class BadgeSet < ActiveRecord::Base
  self.table_name = 'categories'

  default_scope -> { where(:type => 'BadgeSet') }

  belongs_to :course
  has_many :badges, :foreign_key => :assignment_type

  validates_presence_of :course, :name
end

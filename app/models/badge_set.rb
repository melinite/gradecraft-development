class BadgeSet < ActiveRecord::Base
  self.table_name = 'categories'

  default_scope -> { where(:type => 'BadgeSet') }

  attr_accessible :course, :name

  belongs_to :course
  has_many :badges, :foreign_key => :category_id

  validates_presence_of :course, :name
end

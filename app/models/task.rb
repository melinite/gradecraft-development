class Task < ActiveRecord::Base
  belongs_to :assignment
  has_one :submission

  attr_accessible :assignment

  validates_presence_of :assignment
end

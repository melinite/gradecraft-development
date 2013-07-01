class Task < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :submission

  validates_presence_of :assignment
end

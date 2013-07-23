class AbstractGrade < ActiveRecord::Base
  self.table_name = 'grades'

  validates_presence_of :gradeable

  belongs_to :course
  belongs_to :submission

  belongs_to :gradeable, :polymorphic => :true
  accepts_nested_attributes_for :gradeable
end

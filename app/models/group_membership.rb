class GroupMembership < ActiveRecord::Base
  attr_accessible :accepted, :group, :group_id, :user, :user_id

  belongs_to :group, :class_name => 'AbstractGroup'
  belongs_to :user

  validates_presence_of :group, :user
end

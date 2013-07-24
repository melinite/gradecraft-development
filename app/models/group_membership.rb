class GroupMembership < ActiveRecord::Base
  attr_accessible :accepted, :group, :group_id, :user, :user_id

  belongs_to :group, :polymorphic => true
  belongs_to :user

  validates_presence_of :group, :user
end

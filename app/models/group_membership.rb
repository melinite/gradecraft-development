class GroupMembership < ActiveRecord::Base
  attr_accessible :accepted, :group, :group_id, :group_type, :user, :user_id, :course

  belongs_to :group
  belongs_to :student, class_name: 'User'
end

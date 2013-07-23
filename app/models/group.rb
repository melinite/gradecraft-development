class Group < ActiveRecord::Base
  MAX_MEMBERS = 6

  attr_accessible :name, :created_at, :updated_at, :proposal, :approved,
    :assignment_id, :user_ids, :text_proposal

  belongs_to :assignment

  validates_presence_of :assignment
end

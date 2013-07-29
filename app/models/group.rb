class Group < ActiveRecord::Base
  MAX_MEMBERS = 6

  default_scope -> { where(:type => 'Group') }

  attr_accessible :name, :created_at, :updated_at, :proposal, :approved,
    :assignment_id, :user_ids, :text_proposal

  belongs_to :course
  belongs_to :assignment

  has_many :group_memberships, :as => :group
  has_many :students, :through => :group_memberships

  validates_presence_of :assignment, :course, :name
end

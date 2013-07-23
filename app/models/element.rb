class Element < AbstractTask
  belongs_to :badge, :foreign_key => :assignment_id
  has_many :submissions, :dependent => :destroy

  attr_accessible :badge

  validates_presence_of :badge
end

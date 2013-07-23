class Task < AbstractTask
  belongs_to :assignment
  has_many :submissions, :dependent => :destroy

  attr_accessible :assignment

  validates_presence_of :assignment
end

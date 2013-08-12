class CriteriumLevel < ActiveRecord::Base
  attr_accessible :criterium, :criterium_id, :rubric, :rubric_id, :description, :name, :value

  belongs_to :criterium
  belongs_to :rubric

  validates_presence_of :name, :value

  scope :ordered, -> { order('value DESC') }

  private

  def cache_associations
    self.rubric_id ||= criterium.try(:rubric_id)
  end
end

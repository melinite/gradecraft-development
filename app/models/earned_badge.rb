class EarnedBadge < Grade
  before_validation :set_raw_score

  private

  def set_raw_score
    self.raw_score = assignment.point_total
  end
end

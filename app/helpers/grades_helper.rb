module GradesHelper
  def criterium_levels_for_select(criterium)
    criterium.levels.map { |l| [l.name, l.value] }
  end
end

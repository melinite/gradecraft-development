class Blogging < Assignment

  def short?
    !substantial?
  end

  def point_total
    if substantial?
      5000
    else
      1000
    end
  end

  def mass_gradeable?
    false
  end

end
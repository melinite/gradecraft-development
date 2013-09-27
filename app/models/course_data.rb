class CourseData < Struct.new(:course)
  def earned_badge_score_for_student(student)
    earned_badge_scores[student.id]
  end

  def earned_badge_scores
    @earned_badge_scores ||= {}.tap do |earned_badge_scores|
      course.earned_badges.scores_for_students.each do |student_id, score|
        earned_badge_scores[student_id] = score
      end
    end
  end

  def badges
    @badges ||= course.badges
  end

  def badges_shared_for_student?(student)
    badges_shared[student.id]
  end

  def students
    @students ||= course.students.alpha.to_a
  end

  def previous_student(student)
    students[students.index(student) - 1]
  end

  def next_student(student)
    students[students.index(student) + 1]
  end

  private

  def badges_shared
    @badges_shared ||= {}.tap do |badges_shared|
      course.course_memberships.pluck('user_id, shared_badges').each do |student_id, shared_badges|
        badges_shared[student_id] = shared_badges
      end
    end
  end
end

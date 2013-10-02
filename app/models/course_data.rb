class CourseData < Struct.new(:course)
  def cache_keys
    @cache_keys ||= CourseCacheKey.find_by(course_id: course.id)
  end

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

  def assignments
    @assignments ||= course.assignments.includes(:course, assignment_type: [:score_levels]).alphabetical.chronological
  end

  def by_assignment_type
    @by_assignment_type ||= assignments.group_by(&:assignment_type)
  end

  def badges
    @badges ||= course.badges
  end

  def challenges
    @challenges ||= course.challenges
  end

  def students
    @students ||= course.students.alpha
  end

  def students_for_team(team)
    course.students.select { |student| team.student_ids.include? student.id }
  end

  def badges_shared_for_student?(student)
    badges_shared[student.id]
  end

  def teams
    course.teams
  end

  def assignments
    course.assignments
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

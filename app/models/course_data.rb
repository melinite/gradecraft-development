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

  def assignment_types
    @assignment_types ||= course.assignment_types
  end

  def assignments
    @assignments ||= course.assignments.includes(:course, assignment_type: [:score_levels]).alphabetical.chronological
  end

  def group_assignments
    @group_assignments ||= assignments.select { |a| a.grade_scope == 'Group' }
  end

  def by_assignment_type
    @by_assignment_type ||= assignments.group_by(&:assignment_type)
  end

  def grade_for_student_and_assignment(student, assignment)
    assignment_grades(assignment)[student.id] || student.grades.new(assignment: assignment)
  end

  def assignment_grades(assignment)
    (@assignment_grades ||= {})[assignment.id] ||= {}.tap do |grades|
      assignment.grades.includes(:student, :assignment => [:course]).each do |grade|
        grades[grade.student_id] = grade
      end
    end
  end

  def badges
    @badges ||= course.badges.includes(:tasks)
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

  def teams_by_high_score
    @teams ||= course.teams.order_by_high_score
  end

  def teams
    @teams ||= course.teams
  end

  def point_total_for_challenges
    challenges.pluck('point_total').sum
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

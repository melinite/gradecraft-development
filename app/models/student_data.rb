class StudentData < Struct.new(:student, :course)
  def score
    @score ||= released_grades.where(course: course).score + earned_badge_score
  end

  def score_for_assignment_type(assignment_type)
    assignment_type_scores[assignment_type.id]
  end

  def assignment_type_scores
    @assignment_type_scores ||= Hash.new { |h, k| h[k] = 0 }.tap do |assignment_type_scores|
      released_grades.assignment_type_scores.each do |assignment_type_id, score|
        assignment_type_scores[assignment_type_id] = score
      end
    end
  end

  def point_total_for_assignment_type(assignment_type)
    assignment_type_point_totals[assignment_type.id]
  end

  def assignment_type_point_totals
    @assignment_type_point_totals ||= Hash.new { |h, k| h[k] = 0 }.tap do |assignment_type_point_totals|
      course.assignments.assignment_type_point_totals_for_student(student).each do |assignment_type_id, point_total|
        assignment_type_point_totals[assignment_type_id] = point_total
      end
    end
  end

  def point_total_for_assignment(assignment)
    assignment_point_totals[assignment.id]
  end

  def assignment_point_totals
    @assignment_point_totals ||= {}.tap do |assignment_point_totals|
      course.assignments.point_totals_for_student(student).each do |assignment_id, point_total|
        assignment_point_totals[assignment_id] = point_total
      end
    end
  end

  def score_for_assignment(assignment)
    assignment_scores[assignment.id] || 0
  end

  def assignment_scores
    @assignment_scores ||= Hash.new { |h, k| h[k] = 0 }.tap do |assignment_scores|
      released_grades.assignment_scores.each do |assignment_id, score|
        assignment_scores[assignment_id] = score
      end
    end
  end

  def grade_released_for_assignment?(assignment)
    grade_for_assignment(assignment).persisted? && (!assignment.release_necessary? || grade_for_assignment(assignment).is_released?)
  end

  def grade_for_assignment(assignment)
    assignment_grades[assignment.id]
  end

  def assignment_grades
    @assignment_grades ||= Hash.new { |h, k| h[k] = student.grades.new(assignment_id: k) }.tap do |assignment_grades|
      student.grades.each do |grade|
        assignment_grades[grade.assignment_id] = grade
      end
    end
  end

  def point_total
    @point_total ||= course.assignments.point_total_for_student(student) + earned_badge_score
  end

  def grade_level
    @grade_level ||= course.grade_level_for_score(score)
  end

  def earned_badge_score
    @earned_badge_score ||= student.earned_badges.where(course: course).score
  end

  def released_grades
    @released_grades ||= student.grades.released
  end

  def earned_badge?(badge)
    earned_badges[badge.id].present?
  end

  def earned_badges
    @earned_badges ||= {}.tap do |earned_badges|
      student.earned_badges.each do |earned_badge|
        earned_badges[earned_badge.badge_id] = earned_badge
      end
    end
  end

  def weight_for_assignment_type(assignment_type)
    assignment_type_weights[assignment_type.id]
  end

  def weighted_assignments?
    @weighted_assignments_present ||= student.assignment_weights.present?
  end

  def submission_for_assignment?(assignment)
    assignment_submissions[assignment.id].present?
  end

  def submission_for_assignment(assignment)
    assignment_submissions[assignment.id]
  end

  def present_for_class?(assignment)
    grade_for_assignment(assignment).raw_score == assignment.point_total
  end

  private

  def assignment_type_weights
    @assignment_type_weights ||= {}.tap do |assignment_type_weights|
      course.assignment_types.weights_for_student(student).each do |assignment_type_id, weight|
        assignment_type_weights[assignment_type_id] = weight
      end
    end
  end

  def assignment_submissions
    @assignment_submissions ||= {}.tap do |assignment_submissions|
      student.submissions.each do |submission|
        assignment_submissions[submission.assignment_id] = submission
      end
    end
  end
end

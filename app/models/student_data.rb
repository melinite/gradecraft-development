class StudentData < Struct.new(:student, :course)
  def cache_key(*args)
    @cache_keys ||= MembershipCalculation.find_by(course_id: course.id, user_id: student.id)
    args.map do |arg|
      arg.is_a?(Symbol) && @cache_keys[arg.to_s] || arg.to_s
    end
  end

  #Released grades + Badges if they have value + Team score if it's present
  def score
    @score ||= released_grades.where(course: course).score + earned_badge_score + team_score
  end

  #Possible total points for student
  def point_total
    @point_total ||= course.assignments.point_total_for_student(student) + earned_badge_score
  end

  #Grabbing the associated course grade scheme info for a student
  def grade_level
    @grade_level ||= course.grade_level_for_score(score)
  end

  def element_level
    @element_level ||= course.element_for_score(score)
  end

  def grade_letter
    @grade_letter ||= course.grade_letter_for_score(score)
  end

  #Summed score for a type of assignment type
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

  #Summed total points for an assignment type
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

  #Total points for a single assignment
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

  #Points earned for a single assignment
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

  #Checking specifically if there is a released grade for an assignment
  def grade_released_for_assignment?(assignment)
    (grade_for_assignment(assignment).is_graded? && !assignment.release_necessary?) || grade_for_assignment(assignment).is_released?
  end

  #Grabbing the grade for an assignment
  def grade_for_assignment(assignment)
    assignment_grades[assignment.id] || student.grades.new(assignment: assignment)
  end

  def assignment_grades
    @assignment_grades ||= {}.tap do |assignment_grades|
      student.grades.each do |grade|
        assignment_grades[grade.assignment_id] = grade
      end
    end
  end

  #Checking if the student has a submission for an assignment
  def submission_for_assignment?(assignment)
    assignment_submissions[assignment.id].present?
  end

  #Grabbing the submission for an assignment
  def submission_for_assignment(assignment)
    assignment_submissions[assignment.id]
  end

  #Checking if the student's group has a submission for an assignment
  def group_submission_for_assignment?(assignment, group)
    assignment_submissions[assignment.id, group.id].present?
  end

  #Grabbing the student's group for a particular assignment
  def group_for_assignment(assignment)
    assignment_groups.where(assignment: assignment).first
  end

  #Grabbing the challenge score for a student's team
  def score_for_challenge(challenge)

  end

  #Checking specifically if there is a released grade for a challenge
  def grade_released_for_challenge?(challenge)
    (grade_for_challenge(challenge).is_graded? && !challenge.release_necessary?) || grade_for_challenge(challenge).is_released?
  end

  #Grabbing the grade for a challenge
  def grade_for_challenge(challenge)
    challenge_grades[challenge.id]
  end

  def challenge_grades(course)
    @challenge_grades ||= {}.tap do |challenge_grades|
      team_for_course(course).challenge_grades.each do |challenge_grade|
        challenge_grades[challenge_grade.challenge_id] = challenge_grade
      end
    end
  end

  def team
    student.teams.where(course: course).first
  end

  def team_score
    @team_score ||= team.challenge_grade_score
  end

  #Grabbing the challenge submission for a student's team

  #Sum of all earned badges value for a student
  def earned_badge_score
    @earned_badge_score ||= student.earned_badges.where(course: course).score
  end

  def released_grades
    @released_grades ||= student.grades.released
  end

  #Badges
  def earned_badge(badge)
    earned_badges[badge.id]
  end

  def earned_badge?(badge)
    earned_badges[badge.id].present?
  end

  def earned_badges
    @earned_badges ||= {}.tap do |earned_badges|
      student.earned_badges.where(course: course).each do |earned_badge|
        earned_badges[earned_badge.badge_id] = earned_badge
      end
    end
  end

  #Weights
  def weight_for_assignment_type(assignment_type)
    assignment_type_weights[assignment_type.id]
  end

  def weighted_assignments?
    @weighted_assignments_present ||= student.assignment_weights.count > 0
  end

  #What is this?
  def present_for_class?(assignment)
    grade_for_assignment(assignment).raw_score == assignment.point_total
  end

  #Groups for Assignments

  def group_submission_for_assignment?(assignment, group)
    assignment_submissions[assignment.id, group.id].present?
  end

  def group_for_assignment(assignment)
    assignment_groups.where(assignment: assignment).first
  end

  def team
    student.teams.where(course: course).first
  end

  def team_score
    team.challenge_grade_score
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

  def assignment_weights
    @assignment_weights ||= {}.tap do |assignment_weights|
      student.assignment_weights.each do |weights|
        assignment_weights[weights.assignment_id] = weights
      end
    end
  end

  def point_total_for_assignment_redux(assignment)
    assignment.point_total + weight_for_assignment(assignment)
  end

  def weight_for_assignment(assignment)
    assignment_weights[assignment.id]
  end
end

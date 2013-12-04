CREATE OR REPLACE VIEW course_cache_keys AS
  SELECT courses.id,
    courses.id AS course_id,
    md5(concat(courses.id, extract(epoch from updated_at))) AS course_key,
    md5(concat(
      courses.id,
      (SELECT COALESCE(sum(extract(epoch from updated_at)), 0) FROM assignments WHERE assignments.course_id = courses.id),
      (SELECT COALESCE(sum(extract(epoch from updated_at)), 0) FROM assignment_types WHERE assignment_types.course_id = courses.id),
      (SELECT COALESCE(sum(extract(epoch from score_levels.updated_at)), 0)
        FROM assignment_types
        JOIN score_levels on score_levels.assignment_type_id = assignment_types.id
        WHERE assignment_types.course_id = courses.id)
    )) AS assignments_key,
    md5(concat(
      (SELECT sum(extract(epoch from updated_at)) FROM grades WHERE grades.course_id = courses.id)
    )) AS grades_key,
    md5(concat(
      (SELECT COALESCE(sum(extract(epoch from updated_at)), 0) FROM tasks WHERE course_id = courses.id),
      (SELECT COALESCE(sum(extract(epoch from updated_at)), 0) FROM badges WHERE badges.course_id = courses.id),
      (SELECT COALESCE(sum(extract(epoch from updated_at)), 0) FROM earned_badges WHERE earned_badges.course_id = courses.id)
  )) AS badges_key
  FROM courses;

CREATE OR REPLACE
     VIEW released_grades AS
   SELECT grades.*
     FROM grades
     JOIN assignments ON assignments.id = grades.assignment_id
    WHERE (status = 'Released' OR (status = 'Graded' AND NOT assignments.release_necessary));

CREATE OR REPLACE
     VIEW released_challege_grades AS
   SELECT challenge_grades.*
     FROM challenge_grades
     JOIN challenges ON challenges.id = challenge_grades.challenge_id
    WHERE (status = 'Released' OR (status = 'Graded' AND NOT challenges.release_necessary));

CREATE OR REPLACE
     VIEW membership_scores AS
   SELECT m.id AS course_membership_id,
          at.id AS assignment_type_id,
          at.name,
          (SELECT COALESCE(SUM(g.score), 0) AS score
             FROM released_grades AS g
            WHERE g.student_id = m.user_id AND g.assignment_type_id = at.id AND g.course_id = m.course_id)
     FROM course_memberships AS m
     JOIN assignment_types AS at ON at.course_id = m.course_id
 GROUP BY m.id, at.id, at.name;

CREATE OR REPLACE
     VIEW membership_calculations AS
   SELECT m.id,
          m.id AS course_membership_id,
          m.course_id,
          m.user_id,
          md5(concat(
            m.course_id,
            m.user_id,
            (SELECT COALESCE(sum(extract(epoch from updated_at)), 0) FROM earned_badges WHERE course_id = m.course_id and student_id = m.user_id)
          )) AS earned_badges_key,
          md5(concat(
            m.course_id,
            m.user_id,
            (SELECT COALESCE(sum(extract(epoch from updated_at)), 0) FROM submissions WHERE course_id = m.course_id and student_id = m.user_id)
          )) AS submissions_key,
          md5(concat(
            m.course_id,
            m.user_id,
            (SELECT COALESCE(SUM(EXTRACT(epoch FROM updated_at)), 0)
               FROM assignment_weights AS aw
              WHERE aw.student_id = user_id AND aw.course_id = course_id)
          )) AS assignment_weights_key,
          (SELECT COALESCE(sum(point_total), 0) FROM assignments AS a WHERE a.course_id = m.course_id) AS assignment_score,
          (SELECT COALESCE(sum(point_total), 0)
             FROM assignments
            WHERE course_id = m.course_id and user_id = m.user_id
              AND EXISTS(SELECT 1 FROM released_grades WHERE assignment_id = assignments.id AND student_id = m.user_id)
            ) AS in_progress_assignment_score,
          (SELECT COALESCE(sum(score), 0) FROM grades WHERE course_id = m.course_id and student_id = m.user_id) AS grade_score,
          (SELECT COALESCE(SUM(score), 0)
             FROM grades AS g
             JOIN assignments AS a ON g.assignment_id = a.id
            WHERE g.course_id = m.course_id AND g.student_id = m.user_id
              AND (g.status = 'Released' OR (g.status = 'Graded' AND NOT a.release_necessary))
              ) AS released_grade_score,
          (SELECT COALESCE(sum(score), 0) FROM earned_badges WHERE course_id = m.course_id and student_id = m.user_id) AS earned_badge_score,
          (SELECT COALESCE(SUM(challenge_grades.score), 0)
             FROM challenge_grades
             JOIN challenges ON challenge_grades.challenge_id = challenges.id
             JOIN teams ON challenge_grades.team_id = teams.id
             JOIN team_memberships ON team_memberships.team_id = teams.id
            WHERE teams.course_id = m.course_id AND team_memberships.student_id = m.user_id) AS challenge_grade_score,
          (SELECT teams.id
             FROM teams
             JOIN team_memberships ON team_memberships.team_id = teams.id
            WHERE teams.course_id = m.course_id AND team_memberships.student_id = m.user_id ORDER BY team_memberships.updated_at DESC LIMIT 1) AS team_id,
          (SELECT SUM(COALESCE(assignment_weights.point_total, assignments.point_total))
             FROM assignments
        LEFT JOIN assignment_weights ON assignments.id = assignment_weights.assignment_id
                                    AND assignment_weights.student_id = m.user_id
           WHERE assignments.course_id = m.course_id) AS weighted_assignment_score,
          (SELECT COUNT(*) FROM assignment_weights WHERE student_id = m.user_id) AS assignment_weight_count,
          cck.course_key, cck.assignments_key, cck.grades_key, cck.badges_key
     FROM course_memberships AS m
     JOIN course_cache_keys AS cck ON m.course_id = cck.id;

CREATE OR REPLACE VIEW shared_earned_badges AS
  SELECT course_memberships.course_id,
    (users.first_name || ' ' || users.last_name) as student_name,
    users.id as user_id,
    earned_badges.id as id,
    badges.icon, badges.name, badges.id as badge_id
  FROM course_memberships
  JOIN users ON users.id = course_memberships.user_id
  JOIN earned_badges ON earned_badges.student_id = users.id
  JOIN badges ON badges.id = earned_badges.badge_id
  WHERE course_memberships.shared_badges = 't'
    AND badges.icon IS NOT NULL
    AND earned_badges.shared = 't';

CREATE VIEW course_cache_keys AS
  SELECT courses.id,
    courses.id AS course_id,
    md5(concat(courses.id, extract(epoch from updated_at))) AS course_key,
    md5(concat(
      courses.id,
      (SELECT sum(extract(epoch from updated_at)) FROM assignments WHERE assignments.course_id = courses.id),
      (SELECT sum(extract(epoch from updated_at)) FROM assignment_types WHERE assignment_types.course_id = courses.id),
      (SELECT sum(extract(epoch from score_levels.updated_at))
        FROM assignment_types
        JOIN score_levels on score_levels.assignment_type_id = assignment_types.id
        WHERE assignment_types.course_id = courses.id)
    )) AS assignments_key,
    md5(concat(
      (SELECT sum(extract(epoch from updated_at)) FROM grades WHERE grades.course_id = courses.id)
    )) AS grades_key,
    md5(concat(
      (SELECT sum(extract(epoch from updated_at)) FROM tasks WHERE course_id = courses.id),
      (SELECT sum(extract(epoch from updated_at)) FROM badges WHERE badges.course_id = courses.id),
      (SELECT sum(extract(epoch from updated_at)) FROM earned_badges WHERE earned_badges.course_id = courses.id)
  )) AS badges_key
  FROM courses;

CREATE VIEW student_cache_keys AS
  SELECT cm.id,
    cm.id AS course_membership_id,
    cm.course_id,
    cm.user_id,
    md5(concat(
      cm.course_id,
      cm.user_id,
      (SELECT sum(extract(epoch from updated_at)) FROM earned_badges WHERE course_id = cm.course_id and student_id = cm.user_id)
    )) AS earned_badges_key,
    md5(concat(
      cm.course_id,
      cm.user_id,
      (SELECT sum(extract(epoch from updated_at)) FROM submissions WHERE course_id = cm.course_id and student_id = cm.user_id)
    )) AS submissions_key
  FROM course_memberships AS cm;

CREATE OR REPLACE
     VIEW membership_calculations AS
   SELECT m.id,
          m.id AS course_membership_id,
          m.course_id,
          m.user_id,
          md5(concat(
            m.course_id,
            m.user_id,
            (SELECT sum(extract(epoch from updated_at)) FROM earned_badges WHERE course_id = m.course_id and student_id = m.user_id)
          )) AS earned_badges_key,
          md5(concat(
            m.course_id,
            m.user_id,
            (SELECT sum(extract(epoch from updated_at)) FROM submissions WHERE course_id = m.course_id and student_id = m.user_id)
          )) AS submissions_key,
          (SELECT sum(score) FROM grades WHERE course_id = m.course_id and student_id = m.user_id) AS grade_score_sum,
          cck.course_key, cck.assignments_key, cck.grades_key, cck.badges_key
     FROM course_memberships AS m
     JOIN course_cache_keys AS cck ON m.course_id = cck.id;

CREATE VIEW shared_earned_badges AS
  SELECT course_memberships.course_id,
    (users.first_name || ' ' || users.last_name) as student_name,
    users.id as user_id,
    earned_badges.id as id,
    badges.icon, badges.name
  FROM course_memberships
  JOIN users ON users.id = course_memberships.user_id
  JOIN earned_badges ON earned_badges.student_id = users.id
  JOIN badges ON badges.id = earned_badges.badge_id
  WHERE course_memberships.shared_badges = 't'
    AND badges.icon IS NOT NULL
    AND earned_badges.shared = 't';

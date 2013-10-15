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
  FROM courses

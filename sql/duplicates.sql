SELECT COUNT(*) AS count, course_id, assignment_id, student_id,
       (SELECT name FROM assignments WHERE id = g.assignment_id) AS assignment_name,
       (SELECT first_name || ' ' || last_name FROM users WHERE id = g.student_id)
  FROM grades AS g
  GROUP BY course_id, assignment_id, student_id
  HAVING COUNT(*) > 1

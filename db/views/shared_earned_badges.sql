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
    AND earned_badges.shared = 't'

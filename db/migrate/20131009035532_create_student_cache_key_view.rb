class CreateStudentCacheKeyView < ActiveRecord::Migration
  def self.up
    execute <<-SQL
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
             FROM course_memberships AS cm
    SQL
  end
  def self.down
    execute <<-SQL
      DROP VIEW student_cache_keys
    SQL
  end
end

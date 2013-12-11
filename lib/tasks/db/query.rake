namespace :db do
  namespace :query do
    task :gradebook, [:course_id] => [:environment] do |t, args|
      ActiveRecord::Base.transaction do
        connection = ActiveRecord::Base.connection
        assignments = connection.select_all(<<-SQL, nil, [[ nil, args[:course_id] ]])
            SELECT a.id, a.name
              FROM assignments AS a
             WHERE a.course_id = $1
               AND EXISTS (SELECT * FROM grades AS g WHERE g.assignment_id = a.id)
          ORDER BY 2
        SQL

        columns = [ 0 ]
        headers = [ 'Student' ]
        assignments.each do |a|
          headers << a['name']
          columns << a['id']
        end

        grades = connection.select_all(<<-SQL, nil, [[ nil, args[:course_id] ]])
          SELECT m.user_id,
                 last_name || ', ' || first_name AS student, a.id as assignment_id, a.name, g.score
            FROM users
            JOIN course_memberships AS m ON users.id = m.user_id
            JOIN grades AS g on g.course_id = m.course_id AND g.student_id = m.user_id
            JOIN assignments AS a ON m.course_id = a.course_id AND g.assignment_id = a.id
           WHERE m.course_id = $1
        ORDER BY last_name, first_name
        SQL

        rows = []
        row = {}
        user_id = 0
        grades.each do |grade|
          if grade['user_id'] != user_id
            user_id = grade['user_id']
            rows << row
            row = { 0 => grade['student'] }
          end
          row[grade['assignment_id']] = grade['score'] || 0
        end
        rows.shift

        csv = CSV.generate do |csv|
          csv << headers
          rows.each do |values|
            row = []
            columns.each do |id|
              row << values[id]
            end
            csv << row
          end
        end

        puts csv
      end
    end
  end
end

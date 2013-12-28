user_names = ['Ron Weasley','Fred Weasley','Harry Potter','Hermione Granger','Colin Creevey','Seamus Finnigan','Hannah Abbott','Pansy Parkinson','Zacharias Smith','Blaise Zabini', 'Draco Malfoy', 'Dean Thomas', 'Millicent Bulstrode', 'Terry Boot', 'Ernie Macmillan', 'Roland Abberlay', 'Katie Bell', 'Regulus Black', 'Euan Abercrombie', 'Brandon Angel', 'Jada Angela', 'Pete Balsall', 'Allison Barnes', 'Fiona Belmont', 'Kajol Bhatt', 'Sally Birchgrove', 'Stephen Challock', 'Dennis Creevey', 'Lisa Cullen', 'Winky Crocket', 'Fay Dunbar', 'Lily Evans', 'Rosalyn Ewhurst', 'Terrence Fogarty', 'Hamish Frater', 'Vicky Frobisher', 'Godric Gryffindor', 'Ryan Henry', 'David Hamblin', 'Kelly Harborne', 'Thelma Holmes', 'Geoffrey Hooper', 'Carl Hopkins', 'Satoru Lida', 'Nandini Johar', 'Angelina Johnson', 'Lee Jordan']

team_names = ['Harm & Hammer', 'Abusement Park','Silver Woogidy Woogidy Woogidy Snakes','Carpe Ludus','Eduception','Operation Unthinkable','Team Wang','The Carpal Tunnel Crusaders','Pwn Depot']

badge_names = ['Dream Interpreter', 'Inner Eye', 'Patronus Producer','Cheerful Charmer','Invisiblity Cloak','Marauders Map','Lumos','Rune Reader','Tea Leaf Guru','Wizard Chess Grand Master','Green Thumb','Gamekeeper','Seeker','Alchemist','Healer','Parseltongue','House Cup']

badge_icons = ['/badges/above_and_beyond.png','/badges/always_learning.png','/badges/awesome_aggregator.png','/badges/concentrator.png','/badges/courageous_failure.png','/badges/early_bird_special.png','/badges/examination_expert.png','/badges/gaining_experience.png','/badges/gamer.png','/badges/great_critic.png','/badges/learning_from_mistakes.png','/badges/level_one.png','/badges/participatory_democrat.png','/badges/personal.png','/badges/practice_makes_perfect.png','/badges/presentation_of_self.png','/badges/public_speaker.png']

# Use stock badge icons
badge_icon_paths = Dir.glob(Rails.root.join('test/support/assets/*'))

grade_scheme_hash = { [0,600000] => 'F', [600000,649000] => 'D+', [650000,699999] => 'C-', [700000,749999] => 'C', [750000,799999] => 'C+', [800000,849999] => 'B-', [850000,899999] => 'B', [900000,949999] => 'B+', [950000,999999] => 'A-', [1000000,1244999] => 'A', [1245000,1600000] => 'A+'}

majors = ['Obliviator','Knight Bus Driver','Magizoologist','Wandmaker','Mediwizard','Dragonologist','Floo Network Regulator','Curse-Breaker','Broom-maker','Arithmancer','Hit Wizard','Auror']

# Generate sample courses
course = Course.create! do |c|
  c.name = "Videogames & Learning"
  c.courseno = "ED222"
  c.year = Date.today.year
  c.semester = "Winter"
  c.total_assignment_weight = 6
  c.max_assignment_weight = 6
  c.default_assignment_weight = 1
  c.max_group_size = 5
  c.min_group_size = 2
  c.team_setting = true
  c.teams_visible = true
  c.group_setting = true
  c.badge_setting = true
  c.badge_use_scope = "Both"
  c.shared_badges = true
  c.badges_value = true
  c.grade_scheme_id = 1
  c.accepts_submissions = true
  c.predictor_setting = true
  c.graph_display = true
  c.tagline = "You Game the Grade"
  c.academic_history_visible = true
  c.media_file = "http://www.youtube.com/watch?v=LOiQUo9nUFM&feature=youtu.be"
  c.media_credit = "Albus Dumbledore"
  c.media_caption = "The Greatest Wizard Ever Known"
  c.office = "Room 4121 SEB"
  c.phone = "734-644-3674"
  c.class_email = "staff-educ222@umich.edu"
  c.twitter_handle = "barryfishman"
  c.twitter_hashtag = "EDUC222"
  c.location = "Whitney Auditorium, Room 1309 School of Education Building"
  c.office_hours = "Tuesdays, 1:30 pm – 3:30 pm"
  c.meeting_times = "Mondays and Wednesdays, 10:30 am – 12:00 noon"
  c.badge_term = "Achievement"
  c.user_term = "Learner"
  c.assignment_term = "Quest"
  c.group_term = "League"
  c.team_term = "Horde"
  c.team_challenges = true
  c.challenge_term = "Battle"
  c.grading_philosophy ="I believe a grading system should put the learner in control of their own destiny, promote autonomy, and reward effort and risk-taking. Whereas most grading systems start you off with 100% and then chips away at that “perfect grade” by averaging in each successive assignment, the grading system in this course starts everyone off at zero, and then gives you multiple ways to progress towards your goals. Different types of assignments are worth differing amounts of points. Some assignments are required of everyone, others are optional. Some assignments can only be done once, others can be repeated for more points. In most cases, the points you earn for an assignment are based on the quality of your work on that assignment. Do poor work, earn fewer points. Do high-quality work, earn more points. You decide what you want your grade to be. Learning in this class should be an active and engaged endeavor."
  c.media_file = "http://upload.wikimedia.org/wikipedia/commons/3/36/Michigan_Wolverines_Block_M.png"
end
puts "Videogames and Learning has been installed"

grade_scheme = GradeScheme.create(:name => 'N.E.W.T. Grades', :course => course)

grade_scheme_hash.each do |range,letter|
  grade_scheme.elements.create do |e|
    e.letter = letter
    e.low_range = range.first
    e.high_range = range.last
  end
end
puts "Installed the N.E.W.T. grade scheme"


teams = team_names.map do |team_name|
  course.teams.create! do |t|
    t.name = team_name
  end
end
puts "The Team Competition has begun!"

# Generate sample students
students = user_names.map do |name|
  first_name, last_name = name.split(' ')
  username = name.parameterize.sub('-','.')
  User.create! do |u|
    u.username = username
    u.first_name = first_name
    u.last_name = last_name
    u.email = "#{username}@hogwarts.edu"
    u.password = 'uptonogood'
    u.courses << course
    u.teams << teams.sample
  end
end
puts "Generated #{students.count} unruly students"

# Generate sample admin
User.create! do |u|
  u.username = 'albus'
  u.first_name = 'Albus'
  u.last_name = 'Dumbledore'
  u.role = 'admin'
  u.email = 'dumbledore@hogwarts.edu'
  u.password = 'fawkes'
 u.courses << course
end
puts "Albus Dumbledore just apparated into Hogwarts"

# Generate sample professor
User.create! do |u|
  u.username = 'severus'
  u.first_name = 'Severus'
  u.last_name = 'Snape'
  u.role = 'professor'
  u.email = 'snape@hogwarts.edu'
  u.password = 'lily'
  u.courses << course
end
puts "Severus Snape has been spotted in Slytherin House"

# Generate sample GSI
students << User.create! do |u|
  u.username = 'percy.weasley'
  u.first_name = 'Percy'
  u.last_name = 'Weasley'
  u.role = 'gsi'
  u.email = 'percy.weasley@hogwarts.edu'
  u.password = 'bestprefect'
  u.courses << course
end
puts "Percy Weasley has arrived on campus, on time as usual"

#Create demo academic history content
students.each do |s|
  StudentAcademicHistory.create! do |ah|
    ah.student_id = s.id
    ah.major = majors.sample
    ah.gpa = [1.5, 2.0, 2.25, 2.5, 2.75, 3.0, 3.33, 3.5, 3.75, 4.0, 4.1].sample
    ah.current_term_credits = rand(12)
    ah.accumulated_credits = rand(40)
    ah.year_in_school = [1, 2, 3, 4, 5, 6, 7].sample
    ah.state_of_residence = "Michigan"
    ah.high_school = "Hogwarts School of Witchcraft & Wizardry"
    ah.athlete = [false, true].sample
    ah.act_score = 1 * rand(10)
    ah.sat_score = 100 * rand(10)
  end
end
puts "And gave students some background"

rubric = course.rubrics.create! do |r|
  r.name = "The Rubric"
  r.description = "Test Rubric"
end

criteria = 1.upto(3).map do |n|
  criteria = rubric.criteria.create! do |c|
    c.name = "Criterium #{n}"
    c.category = %w(Category1 Category2 Category3).sample
  end
end

criteria.each do |criterium|
  1.upto(3).each do |n|
    criterium.levels.create! do |l|
      l.name = "Level #{n}"
      l.value = 100 * n
    end
  end
end


badges = badge_names.map do |badge_name|
  badges.create! do |b|
    b.name = badge_name
    b.point_total = 100 * rand(10)
    b.icon = File.open(badge_icon_paths.sample)
    b.visible = 1
  end
end
puts "Did someone need motivation? We found these badges in the Room of Requirements..."

badges.each do |badge|
  students.each do |student|
    student.earned_badges.create! do |eb|
      eb.badge = badge
      eb.course = course
    end
  end
end
puts "Earned badges have been awarded"


assignment_types = {}

assignment_types[:attendance] = AssignmentType.create! do |at|
  at.course = course
  at.name = "Attendance"
  at.point_setting = "For All Assignments"
  at.points_predictor_display = "Slider"
  at.resubmission = false
  at.max_value = "120000"
  at.predictor_description = "We will work to build a learning community in EDUC 222, and I want this to be a great learning experience for all. To do this requires that you commit to the class and participate."
  at.universal_point_value = "5000"
  at.due_date_present = true
  at.order_placement = 1
  at.mass_grade = true
  at.mass_grade_type = "Checkbox"
  at.student_logged_button_text = "I'm in class!"
  at.student_logged_revert_button_text = "I couldn't make it"
end
puts "Come to class."

1.upto(5).each do |n|
  assignment_types[:attendance].score_levels.create do |sl|
    sl.name = "#{n}0% of class"
    sl.value = 5000/n
  end
end
puts "Added slider grading levels for attendance"

assignment_types[:reading_reaction] = AssignmentType.create! do |at|
  at.course = course
  at.name = "Reading Reactions"
  at.universal_point_value = 5000
  at.point_setting = "For All Assignments"
  at.points_predictor_display = "Select List"
  at.resubmission = false
  at.predictor_description = "Each week, you must write a concise summary or analysis of the reading for that week of no more than 200 words! (200 words is roughly equivalent to one-half page, double-spaced.) Your 201st word will suffer a terrible fate... "
  at.due_date_present = true
  at.order_placement = 2
  at.mass_grade = true
  at.mass_grade_type = "Select"
  at.student_weightable = true
end
puts "Do your readings."

assignment_types[:reading_reaction].score_levels.create do |sl|
  sl.name = "You Reacted"
  sl.value = 2500
end

assignment_types[:reading_reaction].score_levels.create do |sl|
  sl.name = "Someone Reacted to You"
  sl.value = 5000
end
puts "Added select list grading levels"

assignment_types[:blogging] = AssignmentType.create! do |at|
  at.course = course
  at.name = "Blogging"
  at.point_setting = "By Assignment"
  at.points_predictor_display = "Slider"
  at.resubmission = false
  at.max_value = "60000"
  at.predictor_description = "There will be many issues and topics that we address in this course that spark an interest, an idea, a disagreement, or a connection for you. You will also encounter ideas in your daily life (blogs you read, news reports, etc.) or in your other classes that spark a connection to something you are thinking about in this course. I encourage you to blog these thoughts on Piazza (we will pretend that Piazza is a blogging site for the purposes of this course). These may be analyses, critiques, or reviews of ideas both from and related to the course. Use the blog as a way to expand the range of technology we might consider. Use the blog to challenge ideas. Use the blog to communicate about things you come across in your travels that you think are relevant to the area of teaching and learning with technology.

Note that blog posts must be substantial to earn points. What “substantial” means is at the discretion of the professor (he knows it when he sees it). “Hello World” posts or posts that are simply duplications from other sites are not going to earn you any points. Also, see this insightful resource for information about plagiarism and blogging:
http://www.katehart.net/2012/06/citing-sources-quick-and-graphic-guide.html

You can blog as much as you want, but only one post/week can earn points."
  at.order_placement = 3
  at.mass_grade = true
  at.mass_grade_type = "Radio"
  at.student_weightable = true
end
puts "Blogging is great for filling in missed points in other areas"

assignment_types[:lfpg] = AssignmentType.create! do |at|
  at.course = course
  at.name = "20% Time"
  at.point_setting = "By Assignment"
  at.points_predictor_display = "Slider"
  at.predictor_description = "At Google, all employs were (historically) given 20% of their work time to devote to any project they choose. Often, these projects fold the personal interest or ambitions of the employee into the larger opportunities represented by the context of Google (e.g., high-tech resources and lots of smart folks). In this course, I am requiring that you devote 20% of your time to pursuing a project of interest to you, that benefits you, and that will help you maximize the value of this course for you. You will determine the scope of the project, the requirements of the project, and the final grade for the project. You may work alone or with others. Whether or not there is a “product” is up to you, as is the form of that product. There is only one requirement for this project: You must share or present the project (in some way of your choosing) with your classmates and with me at the final class meeting.

We will make time during class for sharing, design jams, help sessions, etc. as we go along. The point of these sessions will be to inspire each other and yourself by seeing what others are up to. My office hours are also available to you for as much advice and guidance as you want to seek to support your work (sign up at http://bit.ly/16Ws5fm).

At the end of the term, you will tell me how many points out of the 20,000 you have earned.

I look forward to being surprised, elated, and informed by your interests and self-expression."
  at.resubmission = false
  at.due_date_present = true
  at.order_placement = 4
  at.mass_grade = false
  at.student_weightable = true
end
puts "This is the good stuff :)"

assignment_types[:boss_battle] = AssignmentType.create! do |at|
  at.course = course
  at.name = "Boss Battles"
  at.point_setting = "By Assignment"
  at.points_predictor_display = "Set per Assignment"
  at.resubmission = false
  at.due_date_present = true
  at.order_placement = 5
  at.mass_grade = false
end
puts "Challenges!"

grinding_assignments = []

1.upto(30).each do |n|
  grinding_assignments << assignment_types[:attendance].assignments.create! do |a|
    a.name = "Class #{n}"
    a.point_total = 5000
    a.due_at = rand(n - 6).weeks.from_now
    a.accepts_submissions = false
    a.release_necessary = false
    a.grade_scope = "Individual"
    a.student_logged = true
    if n == 2
      a.open_at = 1.day.ago
      a.due_at = 1.day.from_now
    end
  end

  grinding_assignments << assignment_types[:reading_reaction].assignments.create! do |a|
    a.name = "Reading Reaction #{n}"
    a.due_at = rand(n - 6).weeks.ago
    a.accepts_submissions = false
    a.release_necessary = false
    a.grade_scope = "Individual"
    a.rubrics << rubric
  end
end

grinding_assignments.each do |a|
  a.tasks.create! do |t|
    t.assignment = a
    t.name = "Task 1"
    t.due_at = rand.weeks.from_now
    t.accepts_submissions = true
  end
end

puts "Attendance and Reading Reaction classes have been posted!"

grinding_assignments.each do |assignment|
  next unless assignment.due_at.past?
  students.each do |student|
    assignment.tasks.each do |task|
      submission = student.submissions.create! do |s|
        s.task = task
        s.text_comment = "Wingardium Leviosa"
        s.link = "http://www.twitter.com"
      end
      student.grades.create! do |g|
        g.submission = submission
        g.raw_score = assignment.point_total * [0, 1].sample
        g.status = "Graded"
      end
    end
  end
end
puts "Attendance and Reading Reaction scores have been posted!"

blog_assignments = []

1.upto(5).each do |n|
  blog_assignments << Assignment.create! do |a|
    a.assignment_type = assignment_types[:blogging]
    a.name = "Blog Post #{n}"
    a.point_total = 5000
    a.accepts_submissions = true
    a.release_necessary = false
    a.grade_scope = "Individual"
    a.rubrics << rubric
  end

  blog_assignments << Assignment.create! do |a|
    a.assignment_type = assignment_types[:blogging]
    a.name = "Blog Comment #{n}"
    a.point_total = 2000
    a.accepts_submissions = true
    a.release_necessary = false
    a.grade_scope = "Individual"
  end
end

blog_assignments.each do |a|
  a.tasks.create! do |t|
    t.name = "Task 1"
    t.due_at = rand.weeks.from_now
    t.accepts_submissions = true
  end
end

puts "Blogging assignments have been posted!"

blog_assignments.each_with_index do |assignment, i|
  next if i % 2 == 0
  students.each do |student|
    assignment.tasks.each do |task|
      submission = student.submissions.create! do |s|
        s.task = task
        s.text_comment = "Wingardium Leviosa"
        s.link = "http://www.twitter.com"
      end
      student.grades.create! do |g|
        g.submission = submission
        g.raw_score = assignment.point_total * [0, 1].sample
        g.status = "Graded"
      end
    end
  end
end
puts "Blogging scores have been posted!"

assignments = []

assignments << Assignment.create! do |a|
  a.assignment_type = assignment_types[:lfpg]
  a.name = "Game Selection Paper"
  a.point_total = 80000
  a.due_at = rand(3).weeks.ago
  a.accepts_submissions = true
  a.release_necessary = true
  a.open_at = rand(3).weeks.ago
  a.grade_scope = "Individual"
  a.save
  a.tasks.create! do |t|
    t.name = "Task 1"
    t.due_at = rand.weeks.from_now
    t.accepts_submissions = true
  end
  students.each do |student|
    a.tasks.each do |task|
      submission = student.submissions.create! do |s|
        s.task = task
        s.text_comment = "Wingardium Leviosa"
        s.link = "http://www.twitter.com"
      end
      student.grades.create! do |g|
        g.submission = submission
        g.raw_score = 80000 * [0,1].sample
        g.status = "Graded"
      end
    end
  end
end
puts "Game Selection Paper has been posted!"

assignments << Assignment.create! do |a|
  a.assignment_type = assignment_types[:lfpg]
  a.name = "Game Play Update Paper 1"
  a.point_total = 120000
  a.due_at = rand(3).weeks.from_now
  a.accepts_submissions = true
  a.release_necessary = false
  a.open_at = rand(2).weeks.from_now
  a.grade_scope = "Individual"
end
puts "Game Play Update Paper 1 has been posted!"

assignments << Assignment.create! do |a|
  a.assignment_type = assignment_types[:lfpg]
  a.name = "Game Play Update Paper 2"
  a.point_total = 120000
  a.due_at = rand(4).weeks.from_now
  a.accepts_submissions = true
  a.release_necessary = false
  a.open_at = rand(3).weeks.from_now
  a.grade_scope = "Individual"
end
puts "Game Play Update Paper 2 has been posted!"

assignments << Assignment.create! do |a|
  a.assignment_type = assignment_types[:lfpg]
  a.name = "Game Play Reflection Paper"
  a.point_total = 160000
  a.due_at = rand(5).weeks.from_now
  a.accepts_submissions = true
  a.release_necessary = true
  a.open_at = rand(4).weeks.from_now
  a.grade_scope = "Individual"
end
puts "Game Play Reflection Paper has been posted!"

ip1_assignment = Assignment.create! do |a|
  a.assignment_type = assignment_types[:boss_battle]
  a.name = "Individual Paper/Project 1"
  a.point_total = 200000
  a.due_at = rand(4).weeks.from_now
  a.accepts_submissions = true
  a.release_necessary = false
  a.open_at = rand(3).weeks.from_now
  a.grade_scope = "Individual"
end
puts "Individual Project 1 has been posted!"

1.upto(5).each do |n|
  ip1_assignment.assignment_score_levels.create! do |asl|
    asl.name = "Assignment Score Level ##{n}"
    asl.value = 200000/n
  end
end

ip2_assignment = Assignment.create! do |a|
  a.assignment_type = assignment_types[:boss_battle]
  a.name = "Individual Paper/Project 2"
  a.point_total = 300000
  a.due_at = rand(5).weeks.from_now
  a.accepts_submissions = true
  a.release_necessary = false
  a.open_at = rand(4).weeks.from_now
  a.grade_scope = "Individual"
end
puts "Individual Project 2 has been posted!"

1.upto(8).each do |n|
  ip2_assignment.assignment_score_levels.create! do |asl|
    asl.name = "Assignment Score Level ##{n}"
    asl.value = 300000/(9-n)
  end
end

ggd_assignment = Assignment.create! do |a|
  a.assignment_type = assignment_types[:boss_battle]
  a.name = "Group Game Design Project"
  a.point_total = 400000
  a.due_at = rand(7).weeks.from_now
  a.accepts_submissions = true
  a.release_necessary = false
  a.open_at = rand(6).weeks.from_now
  a.grade_scope = "Group"
end
puts "Group Game Design has been posted!"

1.upto(4).each do |n|
  ggd_assignment.assignment_score_levels.create! do |asl|
    asl.name = "Assignment Score Level ##{n}"
    asl.value = 400000/n
  end
end

challenges = []

challenges << Challenge.create! do |c|
  c.course = course
  c.name = "House Cup"
  c.point_total = 1000000
  c.due_at = rand(7).weeks.from_now
  c.accepts_submissions = true
  c.release_necessary = false
  c.open_at = rand(6).weeks.from_now
  c.visible = true
  c.save
  teams.each do |team|
    c.challenge_grades.create! do |cg|
      cg.team = team
      cg.score = 1000000 * [0,1].sample
      cg.status = "Graded"
    end
  end
end
puts "The House Cup Competition begins... "



challenges << Challenge.create! do |c|
  c.course = course
  c.name = "Tri-Wizard Tournament"
  c.point_total = 10000000
  c.due_at = rand(8).weeks.from_now
  c.accepts_submissions = true
  c.release_necessary = false
  c.open_at = rand(8).weeks.from_now
  c.visible = true
end
puts "Are you willing to brave the Tri-Wizard Tournament?"

LTIProvider.create! do |p|
  p.name = 'Piazza'
  p.uid = 'piazza'
  p.launch_url = 'https://piazza.com/connect'
  p.consumer_key = 'piazza.sandbox'
  p.consumer_secret = 'test_only_secret'
end

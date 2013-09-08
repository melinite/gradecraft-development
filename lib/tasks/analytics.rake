namespace :analytics do
  desc "Clear analytics database"
  task :drop do
    STDOUT.puts "Are you sure you want to delete all analytics data? (y/n)"
    input = STDIN.gets.strip
    if input == 'y'
      Rake::Task["db:mongoid:drop"].invoke
    else
      STDOUT.puts "Aborted, analytics intact."
    end
  end

  desc "Populate FnordMetric with events to simulate user activity"
  task :populate => :environment do
    user_count = User.count
    events = [].tap do |e|
      e << :login
      20.times do
        e << :pageview
      end
      10.times do
        e << :predictor
      end
    end
    random_score = Rubystats::NormalDistribution.new

    begin
      puts "Sending lots of events, stop by pressing ^c"
      loop do
        user = User.offset(rand(user_count)).limit(1).first
        if user.is_student?
          event = events.sample
          course = user.courses.sample

          data = case event
                 when :pageview
                   pages = %w(/ /dashboard /users/predictor)
                   {:page => pages.sample}
                 when :login
                   last_login_at = Random.rand(100).hours.ago
                   {:last_login_at => last_login_at}
                 when :predictor
                   if course
                     assignment = course.assignments.sample
                     if assignment
                       possible = assignment.point_total_for_student(user)
                       # Our normal distribution should center its mean around
                       # half of the possible score.
                       # To make sure we get 99.7% of our scores within the range,
                       # we'll multiple by half our range divided by 3 standard deviations.
                       score = (random_score.rng * (possible/2)/3) + possible/2
                       score = [0,score].max
                       score = [possible,score].min
                       {:assignment_id => assignment.id, :score => score.to_i, :possible => possible}
                     else
                       false
                     end
                   else
                     false
                   end
                 end

          attributes = {course_id: course.id, user_id: user.id}
          EventLogger.perform_async(event, attributes.merge(data)) if data
          sleep(rand)
        end
      end
    rescue Interrupt => e
      puts ""
      puts "Stopping."
    end
  end
end

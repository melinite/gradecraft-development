namespace :fnordmetric do
  desc "Populate FnordMetric with events to simulate user activity"

  task :populate => :environment do
    user_count = User.count
    events = [].tap do |e|
      e << :login
      20.times do
        e << :pageview
      end
      10.times do
        e << :predictor_set
      end
    end
    random_score = Rubystats::NormalDistribution.new

    puts "Sending lots of events, stop by pressing ^c"
    loop do
      user = User.offset(rand(user_count)).limit(1).first
      if user.is_student?
        event = events.sample
        args = case event
               when :pageview
                 pages = %w(/ /dashboard /users/predictor)
                 [pages.sample, user]
               when :login
                 [user]
               when :predictor_set
                 course = user.courses.sample
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
                     [user, assignment.id, score.to_i, possible]
                   else
                     false
                   end
                 else
                   false
                 end
               end

        FNORD_METRIC_EVENTS[event].call(*args) if args
        sleep(rand)
      end
    end
  end
end

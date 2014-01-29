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

          attributes = {course_id: course.id, user_id: user.id, user_role: user.role}
          EventLogger.perform_async(event, attributes.merge(data)) if data
          sleep(rand)
        end
      end
    rescue Interrupt => e
      puts ""
      puts "Stopping."
    end
  end

  desc "Delete event and adjust aggregates accordingly"
  # Pass criteria unix-variable-style (due to limitations in allowed rake task argument formatting
  # which don't allow passing objects, json, special characters, or anything comma-separated).
  #
  # Running:
  # rake 'analytics:delete_events[event_type=some_type some_attribute=0]'
  #
  # Results in criteria:
  # #=> {:event_type => "some_type", :some_attribute => 0}
  #
  task :delete_events, [:criteria] => [:environment] do |t, args|
    criteria_array = args[:criteria].split(/\s+/).map{ |a| a.split('=') }
    criteria_hash = Hash[ criteria_array.map{ |k,v| [k.strip,convert(v.strip)] } ]

    mongoid_criteria = Analytics::Event.where(criteria_hash)
    STDOUT.puts "Events matching #{mongoid_criteria} selector #{mongoid_criteria.selector}"
    events = mongoid_criteria.to_a

    STDOUT.puts "Found #{events.size} events."
    STDOUT.print "Are you sure you want to delete these events? (y/n) "

    input = STDIN.gets.strip
    if input == 'y'
      STDOUT.puts "Deleting events and adjusting aggregate data..."
      events.each do |e|
        #e = events.first
        if aggregates = Analytics.configuration.event_aggregates.stringify_keys[e.event_type]
          aggregates.each { |a| a.decr(e) }
        end
        e.destroy
      end
      STDOUT.puts "Done!"
    else
      STDOUT.puts "Aborted, events left intact."
    end
  end

  desc "Delete and rebuild aggregate data from stored events"
  task :rebuild_aggregate, [:aggregate] => [:environment] do |t, args|
    aggregate = args[:aggregate].constantize
    STDOUT.print "Are you sure you want to delete all #{aggregate} aggregate data and rebuild from stored events? (y/n) "

    input = STDIN.gets.strip
    if input == 'y'
      STDOUT.puts "Deleting #{aggregate} data."
      aggregate.destroy_all

      events = Analytics::Event
      count = events.count
      STDOUT.puts "Rebuilding from #{count} events."
      aggregates_hash = Analytics.configuration.event_aggregates.stringify_keys

      per_batch = 1000
      0.step(count, per_batch) do |offset|
        events.limit(per_batch).skip(offset).each_with_index do |e, i|
          STDOUT.print "\rBatch #{(offset+per_batch)/per_batch}, Event #{i+offset} out of #{count} - #{((i+offset)*100/count.to_f).to_i}% done"
          aggregates = aggregates_hash[e.event_type]
          if aggregates.include? aggregate
            aggregate.incr(e)
          end
        end
      end

      STDOUT.puts "\nDone!"
    else
      STDOUT.puts "Aborted, aggregate data left intact."
    end
  end

  desc "Export course events"
  task :export_courses => [:environment] do
    course_ids = Analytics::Event.distinct(:course_id)
    export_dir = ENV['EXPORT_DIR']
    course_ids.each do |id|
      puts "Exporting for course: #{id}"

      #puts "Generating JSON export files"
      #%w(analytics_events course_events course_role_events course_predictions course_user_events course_pageviews course_user_pageviews course_user_page_pageviews course_pageview_by_times course_page_pageviews course_role_pageviews course_role_page_pageviews course_logins course_role_logins course_user_logins).each do |aggregate|
        #`mongoexport --db grade_craft_development --collection #{aggregate} --query '{"course_id": #{id}}' --out #{File.join(export_dir, id.to_s, "json", "#{aggregate}.json")}`
      #end

      puts "Generating CSV reports"
      # course user pageviews
      `mongoexport --db grade_craft_development --fields user_id,pages._all.all_time --collection course_user_pageviews --query '{"course_id": #{id}}' --out #{File.join(export_dir, id.to_s, "csv", "course_user_pageviews_total.csv")} --csv`
      # course user logins
      `mongoexport --db grade_craft_development --fields user_id,all_time.count --collection course_user_logins --query '{"course_id": #{id}}' --out #{File.join(export_dir, id.to_s, "csv", "course_user_logins_total.csv")} --csv`
      # course user predictor events
      `mongoexport --db grade_craft_development --fields user_id,events.predictor.all_time --collection course_user_events --query '{"course_id": #{id}}' --out #{File.join(export_dir, id.to_s, "csv", "course_user_predictor_events_total.csv")} --csv`
      # course user predictor pageviews
      `mongoexport --db grade_craft_development --fields "user_id,all_time" --collection course_user_page_pageviews --query '{"course_id": #{id}, "page": "/dashboard#predictor"}' --out #{File.join(export_dir, id.to_s, "csv", "course_user_predictor_pageviews_total.csv")} --csv`
      # user predictor events with role, assignment, prediction score, and datetime
      `mongoexport --db grade_craft_development --fields user_id,user_role,assignment_id,score,possible,created_at --collection analytics_events --query '{"course_id": #{id}, "event_type": "predictor"}' --out #{File.join(export_dir, id.to_s, "csv", "course_user_predictor_events.csv")} --csv`
      # user event with page, event, and datetime
      `mongoexport --db grade_craft_development --fields user_id,user_role,event_type,page,created_at --collection analytics_events --query '{"course_id": #{id}}' --out #{File.join(export_dir, id.to_s, "csv", "course_user_events.csv")} --csv`
    end

    puts "Done!"
  end

  def convert(value)
    begin
      (float = Float(value)) && (float % 1.0 == 0) ? float.to_i : float
    rescue
      value
    end
  end
end

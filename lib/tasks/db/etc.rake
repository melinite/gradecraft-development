namespace :db do
  namespace :etc do
    task :load => :environment do
      puts "Loading views, etc..."
      ActiveRecord::Base.transaction do
        execute File.read(Rails.root.join 'db', 'etc.sql')
      end
    end

    task :drop => :environment do
      puts "Dropping views, etc..."
      ActiveRecord::Base.transaction do
        views = File.read(Rails.root.join 'db', 'etc.sql').scan(/CREATE\s+(OR REPLACE\s+)?VIEW\s+(?<name>[^\s]+)\s+AS/).flatten
        views.reverse.each do |view|
          execute "DROP VIEW IF EXISTS #{view}"
        end
      end
    end

    task :reload do
      Rake::Task['db:etc:drop'].invoke
      Rake::Task['db:etc:load'].invoke
    end

    def execute(query)
      ActiveRecord::Base.connection.execute(query)
    end
  end
end

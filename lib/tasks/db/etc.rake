namespace :db do
  namespace :etc do
    task :load => :environment do
      puts "Loading views, functions, and triggers..."
      execute File.read(Rails.root.join 'db', 'etc.sql')
    end

    task :drop => :environment do
      puts "Dropping views, functions, and triggers..."
      views = File.read(Rails.root.join 'db', 'etc.sql').scan(/CREATE\s+(OR REPLACE\s+)?VIEW\s+(?<name>[^\s]+)\s+AS/).flatten
      views.reverse.each do |view|
        execute "DROP VIEW IF EXISTS #{view}"
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

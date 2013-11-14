namespace :db do
  namespace :etc do
    task :load => :environment do
      ActiveRecord::Base.transaction do
        execute File.read(Rails.root.join 'db', 'etc', "#{version}.sql")
      end
      puts "Loaded db/etc/#{version}.sql"
    end

    task :drop => :environment do
      ActiveRecord::Base.transaction do
        views = File.read(Rails.root.join 'db', 'etc', "#{version}.sql").scan(/CREATE\s+(OR REPLACE\s+)?VIEW\s+(?<name>[^\s]+)\s+AS/).flatten
        views.reverse.each do |view|
          execute "DROP VIEW IF EXISTS #{view}"
        end
      end
      puts "Dropped db/etc/#{version}.sql"
    end

    task :reload do
      Rake::Task['db:etc:drop'].invoke
      Rake::Task['db:etc:load'].invoke
    end

    def execute(query)
      ActiveRecord::Base.connection.execute(query)
    end

    def version
      @version ||= ENV['VERSION'] || `ls -t #{Rails.root.join 'db', 'etc'} | head -n 1`.match(/(\d+)\.sql/)[1]
    end
  end
end

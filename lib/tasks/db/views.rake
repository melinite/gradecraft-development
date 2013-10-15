namespace :db do
  namespace :views do
    task :load => :environment do
      puts "Loading views..."
      load_view :course_cache_keys
    end

    task :drop => :environment do
      puts "Dropping views..."
      drop_view :course_cache_keys
    end

    task :reload do
      Rake::Task['db:views:drop'].invoke
      Rake::Task['db:views:load'].invoke
    end

    def load_view(name)
      execute File.read(Rails.root.join 'db', 'views', "#{name}.sql")
    end

    def drop_view(name)
      execute "DROP VIEW IF EXISTS #{name}"
    end

    def execute(query)
      ActiveRecord::Base.connection.execute(query)
    end
  end
end

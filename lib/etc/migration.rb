module Etc
  module Migration
    def exec_migration(conn, direction)
      before_migrate
      super
      after_migrate
    end

    def before_migrate
      say "bundle exec rake db:etc:drop", true do
        Rake::Task['db:etc:drop'].invoke
      end
    end

    def after_migrate
      say "bundle exec rake db:etc:load", true do
        Rake::Task['db:etc:load'].invoke
      end
    end
  end
end

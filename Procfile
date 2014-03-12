web: bundle exec puma -p $PORT
redis: redis-server --port 7372
bg: bundle exec sidekiq --config ./config/sidekiq.yml
mongo: bundle exec mongod --dbpath=/var/lib/mongodb

web: bundle exec puma -p $PORT
# redis: redis-server /usr/local/etc/redis.conf
bg: bundle exec sidekiq --config ./config/sidekiq.yml
mongo: bundle exec mongod --dbpath=/var/lib/mongodb

#sh start_redis.sh
#sh coffee_watch.sh &
bundle exec thin-websocket -R config.ru start

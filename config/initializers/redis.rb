#Setup redis for Heroku
redis = Redis.new(url: ENV["REDIS_URL"])
module ReadCache
  class << self
    def redis
      unless Rails.env.test?
        @redis ||= Redis::Namespace.new('limiter_app', redis: Redis.new)
      else
        @redis ||= MockRedis.new
      end
    end
  end
end

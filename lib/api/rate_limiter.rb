module Api
  # API Rate Limiter is a special counter that is used to limit the rate
  # at which an operation can be performed.
  class RateLimiter
    attr_reader :result

    def initialize(controller_name, action_name, ip_address, request_limit, expire_in_seconds)
      @key = 'ip_address' << ip_address << controller_name << action_name
      @request_limit = request_limit || 0
      @expire_in_seconds = expire_in_seconds || 0
      @result = { limit_request: false, seconds_left: 0 } # default values
    end

    def perform_limit_request
      if key_exist?
        if key_count >= @request_limit
          @result[:limit_request] = true # request exceed limit
          @result[:seconds_left] = key_expire_in_seconds
        else
          increment_key! # increment key count + 1
        end
      else
        create_key! # add key
      end
      @result # return a hash value
    end

    def create_key!
      ReadCache.redis.set(@key, 1)
      ReadCache.redis.expire(@key, @expire_in_seconds)
    end

    def increment_key!
      ReadCache.redis.incr(@key)
      ReadCache.redis.expire(@key, @expire_in_seconds)
    end

    def key_expire_in_seconds
      ReadCache.redis.ttl(@key).to_i
    end

    def key_count
      ReadCache.redis.get(@key).to_i
    end

    def key_exist?
      ReadCache.redis.get(@key) != nil
      end

  end
end

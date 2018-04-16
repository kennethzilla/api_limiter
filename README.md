# API limiter

It is written in Ruby 2.4.2 and Rails 5.1.6

# Dependencies

Ruby, Rails, Redis and PostgresSQL

# Redis Configuration

limiter/config/initializers/redis.rb

# How to run the MiniTest Test suite

rails test


# Example Usage

```
  def index
    # max 100 requests per hour (3600 seconds) 
    limit = 100
    expire_seconds = 3600
    result = limit_api_requests(limit, expire_seconds)

    if result[:limit_request]
      render :status => 429, plain: "Rate limit exceeded. Try again in #{result[:seconds_left]} seconds"
    else
      render plain: "ok"
    end

  end
```
# Conclusion

After careful consideration, I went with Redis approach instead of the traditional PostgreSQL approach. 

This is because Redis allows us to store and query data in a fast and efficient way (This is because Redis is an in-memory database which operates in RAM memory). 

Most importantly Redis is an external database source so it can share across multiple servers.

This solution allows for customisation of the limit of calls, restriction time length and different limits can be imposed across different controllers and actions.

I've added test specs that test the RateLimiter class. 

And also I've used Rubocop gem to enforce Ruby Style Guide standard to the code. 

Improvements
Could have applied the logic to the Rack layer instead of the Application layer.
Could have extracted the code to a Gem 

require "test_helper"
class Api::RateLimiterTest < ActiveSupport::TestCase

  def setup
    @rate_limiter = Api::RateLimiter.new('home', 'index', '123.135.134.234', 5, 30)
    @rate_limiter.perform_limit_request
  end



  test 'check if rate limiter constraint working ' do
    5.times { @rate_limiter.perform_limit_request }
    assert @rate_limiter.result[:limit_request]
  end

  test 'valid rate limiter initial count method ' do
    assert_equal 1, @rate_limiter.key_count
  end

  test 'valid rate limiter increment method ' do
    @rate_limiter.increment_key!
    assert_equal 2, @rate_limiter.key_count
  end

  test 'ensure increment method return Numeric value ' do
    assert_kind_of Numeric, @rate_limiter.key_count
  end

  test 'ensure key_expire_in_seconds method return Numeric value ' do
    assert_kind_of Numeric, @rate_limiter.key_expire_in_seconds
  end

  test 'ensure key_exist? method return true value ' do
    assert @rate_limiter.key_exist?
  end

  test 'ensure result limit_request value from perform_limit_request method return accordingly ' do
    assert_not  @rate_limiter.result[:limit_request]
  end

  test 'ensure result second_left value from perform_limit_request method return accordingly ' do
    assert_equal 0, @rate_limiter.result[:second_left]
  end


  def teardown
   ReadCache.redis.flushall # clear everything in test redis db
 end

end

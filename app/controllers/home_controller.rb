class HomeController < ApplicationController
  def index
    # max 100 requests per hour (3600 seconds) for home/index action
    limit = 100
    expire_seconds = 3600
    result = limit_api_requests(limit, expire_seconds)

    if result[:limit_request]
      render :status => 429, plain: "Rate limit exceeded. Try again in #{result[:seconds_left]} seconds"
    else
      render plain: "ok"
    end

  end
end

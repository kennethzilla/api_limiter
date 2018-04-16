class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def limit_api_requests(request_limit, expire_seconds)
    requestor = Api::RateLimiter.new(controller_name, action_name, request.remote_ip, request_limit, expire_seconds)
    requestor.perform_limit_request # limit request applies for a specific controller and action
  end


end

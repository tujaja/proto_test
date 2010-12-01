# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details


  include SslRequirement

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  protected

  def notice_for str
    flash[:notice] = "#{str}  (#{to_japan_time(Time.now)})"
  end

  def to_japan_time time
    "#{time.year}年#{time.month}月#{time.day}日#{time.hour}時#{time.min}分"
  end
end

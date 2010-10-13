class AdminController < ApplicationController
  include AuthenticatedSystem

  def index
    if !logged_in? 
      redirect_to admin_login_path
    end


  end

  protected
  def check_admin_authentication
    p '[check_admin_authentication]'
    if logged_in?
      p '-->[logged_in]'
    else
      p '-->[not logged_in]'
      flash[:notice] = "You need to log in!"
      redirect_to :controller=>"/admin", :action=>"index"
    end
  end

end

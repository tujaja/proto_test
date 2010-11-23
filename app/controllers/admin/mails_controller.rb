class Admin::MailsController < AdminController
  before_filter :check_admin_authentication

  def index
  end

  def send_mail
    MultiMailer.deliver_multipurpose('tujaja2@gmail.com', 'secret')
    render :action => 'index'
  end

end

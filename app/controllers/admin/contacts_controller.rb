class Admin::ContactsController < AdminController

  def index
    @contacts = Contact.find(:all)

    respond_to do |format|
      format.html
    end
  end

  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js # show.rjs
    end
  end

  def edit_reply
    @contact = Contact.find(params[:id])
    @mail = Mail.new

    respond_to do |format|
      format.html # edit_reply.html.erb
      format.js   # edit_reply.rjs
    end
  end

  def update
    @contact = Contact.find(params[:id])

    case params[:command]
    when "send_reply"
      update_send_reply
    else
    end
  end

  private

    def update_send_reply
      p 'update_send_reply'
    end

end

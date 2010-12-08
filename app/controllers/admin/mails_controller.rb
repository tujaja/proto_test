class Admin::MailsController < AdminController

  def index
    @mails = Mail.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @mail = Mail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js # show.rjs
    end
  end

  def new
    @mail = Mail.new
    @mails = Mail.all

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.rjs
    end
  end

  def create
    p 'create'
    p params
    @mail = Mail.new(params[:mail])
    @mail.mail_type = 'S'
    @mail.status = 'draft'
    @mail.sent_on = Time.now
    saved = @mail.save

    p 'now sending mail'

    ret = @mail.send_mail
    ret = true
    @mail.update_attribute(:status, 'sent') if ret

    # メールが正しく送れたかどうかどうやって判定すれば良いのだろう

    info = ret ? "「#{@mail.recipients}」宛にメールを送信しました" : 'メールの送信に失敗しました'
    notice_for info

    respond_to do |format|
      format.html { redirect_to admin_artists_path }
      format.js { @mails = Mail.all } # create.rjs
    end
  end

  def destroy
    @mail = Mail.find(params[:id])
    subject = @mail.subject
    @mail.destroy
    notice_for "メール 「#{subject}」 を削除しました。"

    respond_to do |format|
      format.html { redirect_to admin_labels_path }
      format.js { @mails = Mail.all } # destroy.rjs
    end
  end
end

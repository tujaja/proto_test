class OrderMailer < ActionMailer::Base

  def download_notification(order)
    setup_email(order)
    @subject    += 'ダウンロードコンテンツご購入完了'
    @body[:url]  = "http://localhost:3000/download/#{order.token}"
  end

  protected
    def setup_email(order)
      @recipients  = "#{order.email}"
      @from        = "ADMINEMIL"
      @subject     = "[YOURSITE] "
      @sent_on     = Time.now
    end

end

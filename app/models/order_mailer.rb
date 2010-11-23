class OrderMailer < ActionMailer::Base

  def download_notification(order)
    setup_email(order)
    @subject    += 'ダウンロードコンテンツご購入完了'
    @body[:url]  = "#{APP_CONFIG['url']}/download/#{order.token}"
  end

  protected
    def setup_email(order)
      @recipients  = "#{order.email}"
      @from        = "#{APP_CONFIG['site_name']} <deliver@3shimeji.com>"
      @subject     = "#{APP_CONFIG['site_name']}"
      @sent_on     = Time.now
    end
end

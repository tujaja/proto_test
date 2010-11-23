class MultiMailer < ActionMailer::Base
  def multipurpose(recipients, subject)
    @recipients = recipients
    @from = 'admin@3shimeji.com'
    @subject = subject
    @sent_on = Time.now
  end
end

class MultiMailer < ActionMailer::Base
  def multipurpose(recipients, from,  subject, body, sent_on)
    @recipients = recipients
    @from = from
    @subject = subject
    @body = body
    @sent_on = sent_on
  end
end

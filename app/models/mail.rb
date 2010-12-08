class Mail < ActiveRecord::Base

  def send_mail
    ret = MultiMailer.deliver_multipurpose(self.recipients, self.from, self.subject, self.body, self.sent_on)
  end

end

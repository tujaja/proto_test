class SampleMails < ActiveRecord::Migration
  def self.up
    rcpt = 'tujaja2@gmail.com'
    from = 'info@3shimeji.com'
    subject = '話をしよう'
    body = 'あれは今から1万2000年前、いや'
    deliver = 'S'
    status = 'sent'
    kind = 'normal'

    Mail.create(:recipients => rcpt, :from => from, :subject => subject, :body => body,
                :deliver => deliver, :status => status, :kind => kind)

  end

  def self.down
  end
end

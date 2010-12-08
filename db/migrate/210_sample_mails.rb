class SampleMails < ActiveRecord::Migration
  def self.up
    rcpt = 'tujaja2@gmail.com'
    from = 'info@3shimeji.com'
    subject = '話をしよう'
    body = 'あれは今から1万2000年前、いや'
    mail_type = 'S'
    status = 'sent'

    Mail.create(:recipients => rcpt, :from => from, :subject => subject, :body => body,
                :mail_type => mail_type, :status => status)

  end

  def self.down
  end
end

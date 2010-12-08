class CreateMails < ActiveRecord::Migration
  def self.up
    create_table :mails do |t|

      t.string  :recipients,   :null => false, :limit => 200
      t.string  :from,         :null => false, :limit => 50
      t.string  :subject,      :default => "", :limit => 200
      t.text    :body,         :default => "", :limit => 1000
      t.string  :mail_type,    :null => false, :limit => 1 # R or S
      t.string  :status,       :null => false, :limit => 10
      # 'draft' 'sent'

      t.datetime :sent_on
      t.datetime :recieved_on

      t.timestamps
    end
  end

  def self.down
    drop_table :mails
  end
end

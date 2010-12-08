class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|

      t.string  :name,         :null => false, :limit => 30
      t.string  :email,        :null => false, :limit => 50
      t.string  :about,        :null => false, :limit => 30
      t.text    :message,      :null => false, :limit => 500
      t.string  :status,       :default => 'recieved', :null => false, :limit => 10 
      # 'recieved'

      t.datetime :contact_time

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end

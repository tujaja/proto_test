class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string  :name,         :null => false, :limit => 30
      t.string  :mail,         :null => false, :limit => 50
      t.string  :about,        :limit => 30
      t.text    :message,      :null => false, :limit => 500
      t.datetime :contact_time

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end

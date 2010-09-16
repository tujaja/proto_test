class CreateLabels < ActiveRecord::Migration
  def self.up
    create_table :labels do |t|
      t.string  :token,        :null => false, :limit => 100
      t.string  :domain,         :null => false, :limit => 50
      t.string  :name,         :null => false, :limit => 50
      t.string  :subname,      :limit => 50
      t.text    :description,  :limit => 1000
      t.text    :url,          :limit => 50
      t.text    :mail,         :limit => 50
      t.text    :address,      :limit => 50
      t.text    :phone,        :limit => 20 

      t.timestamps
    end
  end

  def self.down
    drop_table :labels
  end
end

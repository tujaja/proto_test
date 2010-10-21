class CreateLabels < ActiveRecord::Migration
  def self.up
    create_table :labels do |t|
      t.string  :token,        :null => false, :limit => 50
      t.string  :domain,       :null => false, :limit => 30
      t.string  :name,         :null => false, :limit => 30
      t.string  :subname,      :limit => 30
      t.text    :description,  :limit => 500
      t.text    :url,          :limit => 50
      t.text    :mail,         :limit => 50
      t.text    :address,      :limit => 50
      t.text    :phone,        :limit => 15

      t.timestamps
    end
  end

  def self.down
    drop_table :labels
  end
end

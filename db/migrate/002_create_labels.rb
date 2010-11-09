class CreateLabels < ActiveRecord::Migration
  def self.up
    create_table :labels do |t|
      t.string  :token,        :null => false, :limit => 50
      t.string  :domain,       :null => false, :limit => 30
      t.string  :name,         :null => false, :limit => 30
      t.string  :subname,      :limit => 30
      t.text    :description,  :limit => 200
      t.string  :url,          :limit => 50
      t.string  :mail,         :limit => 50
      t.string  :address,      :limit => 50
      t.string  :phone,        :limit => 15

      t.timestamps
    end
  end

  def self.down
    drop_table :labels
  end
end

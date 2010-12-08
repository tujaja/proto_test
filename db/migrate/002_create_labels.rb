class CreateLabels < ActiveRecord::Migration
  def self.up
    create_table :labels do |t|
      t.string  :token,        :null => false, :limit => 50
      t.string  :domain,       :null => false, :limit => 30
      t.boolean :activated,    :default => false, :null => false

      t.string  :name,         :null => false, :limit => 30
      t.string  :subname,      :default => "", :limit => 30
      t.text    :description,  :default => "", :limit => 200
      t.string  :url,          :default => "", :limit => 50
      t.string  :email,        :default => "", :limit => 50
      t.string  :address,      :default => "", :limit => 50
      t.string  :phone,        :default => "", :limit => 15

      t.integer :primary_image_id

      t.timestamps
    end
  end

  def self.down
    drop_table :labels
  end
end

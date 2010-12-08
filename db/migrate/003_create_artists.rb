class CreateArtists < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
      t.string  :token,        :null => false, :limit => 50
      t.string  :domain,       :null => false, :limit => 30
      t.boolean :activated,    :default => false, :null => false

      t.string  :name,         :null => false, :limit => 30
      t.string  :subname,      :default => "", :limit => 30
      t.text    :description,  :default => "", :limit => 500
      t.text    :url,          :default => "", :limit => 50
      t.text    :email,        :default => "", :limit => 50

      t.integer :label_id # belongs_to label
      t.integer :primary_image_id

      t.timestamps
    end
  end

  def self.down
    drop_table :artists
  end
end

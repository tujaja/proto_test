class CreateArtists < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
      t.string  :token,        :null => false, :limit => 50
      t.string  :domain,       :null => false, :limit => 30
      t.boolean :activated,    :default => false, :null => false

      t.string  :name,         :null => false, :limit => 30
      t.string  :subname,      :limit => 30
      t.text    :description,  :limit => 500
      t.text    :url,          :limit => 50
      t.text    :mail,         :limit => 50

      t.integer :label_id # belongs_to label

      t.timestamps
    end
  end

  def self.down
    drop_table :artists
  end
end

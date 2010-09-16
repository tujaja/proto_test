class CreateArtists < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
      t.string  :token,        :null => false, :limit => 100
      t.string  :domain,       :null => false, :limit => 50
      t.string  :name,         :null => false, :limit => 50
      t.string  :subname,      :limit => 50
      t.text    :description,  :limit => 1000
      t.text    :url,          :limit => 100
      t.text    :mail,         :limit => 100

      t.integer :label_id # belongs_to label

      t.timestamps
    end
  end

  def self.down
    drop_table :artists
  end
end

class CreateAlbumInfos < ActiveRecord::Migration
  def self.up
    create_table :album_infos do |t|
      t.string  :file_encoding,  :default => "", :limit => 10
      t.string  :total_time,     :default => "", :limit => 10

      t.integer :download_id

      t.timestamps
    end
  end

  def self.down
    drop_table :album_infos
  end
end

class CreateAlbumInfos < ActiveRecord::Migration
  def self.up
    create_table :album_infos do |t|
      t.string  :file_encoding,  :default => "", :limit => 10
      t.string  :compress_format,  :default => "", :limit => 10
      t.integer :music_count,    :default => 0

      t.integer :download_id

      t.timestamps
    end
  end

  def self.down
    drop_table :album_infos
  end
end

class CreateMusicInfos < ActiveRecord::Migration
  def self.up
    create_table :music_infos do |t|
      t.string :file_encoding,  :default => "", :limit => 10
      t.string :time,           :default => "", :limit => 10
      t.text   :lyric,          :defaule => "", :limit => 500

      t.integer :download_id # belongs_to :download
      t.integer :album_info_id # belongs_to :album_info

      t.timestamps
    end
  end

  def self.down
    drop_table :music_infos
  end
end

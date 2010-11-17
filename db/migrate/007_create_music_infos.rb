class CreateMusicInfos < ActiveRecord::Migration
  def self.up
    create_table :music_infos do |t|
      t.string :file_encoding
      t.string :time
      t.text   :lyric

      t.integer :download_id # belongs_to :download
      t.integer :album_info_id # belongs_to :album_info

      t.timestamps
    end
  end

  def self.down
    drop_table :music_infos
  end
end

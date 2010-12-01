class AlbumInfo < ActiveRecord::Base
  belongs_to :download
  has_many :music_infos

  def connect_music(music_id, flag=true)
    p "connect_music #{music_id}"

    music_info = MusicInfo.find_by_id(music_id)
    if flag
      self.music_infos << music_info if music_info
    else
      self.music_infos.delete music_info  if music_info
    end
  end

end

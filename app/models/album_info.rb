class AlbumInfo < ActiveRecord::Base
  belongs_to :download
  has_many :music_infos

  def connect_music(music_id, flag=true)
    music_info = MusicInfo.find_by_id(music_id)
    count = self.music_count
    if flag
      self.music_infos << music_info if music_info
      self.update_attribute(:music_count, count+1)
      p 'here'
    else
      self.music_infos.delete music_info  if music_info
      self.update_attribute(:music_count, count-1) if count > 0
    end
  end

end

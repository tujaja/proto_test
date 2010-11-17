class AlbumInfo < ActiveRecord::Base
  belongs_to :download
  has_many :music_infos

end

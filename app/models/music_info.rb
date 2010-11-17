class MusicInfo < ActiveRecord::Base
  belongs_to :download
  belongs_to :album_info
  has_one    :content, :as => :attachable_info
end
